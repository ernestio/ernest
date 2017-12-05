package steps

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"os"
	"os/exec"
	"path"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"time"

	"github.com/dgryski/dgoogauth"
	aes "github.com/ernestio/crypto/aes"
	ecc "github.com/ernestio/ernest-config-client"
	"github.com/nats-io/nats"
	"github.com/tidwall/gjson"

	. "github.com/gucumber/gucumber"
)

var lastOutput string
var lastError error
var cfg *ecc.Config
var n *nats.Conn
var serviceName string

var messages map[string][][]byte
var sub *nats.Subscription

func init() {
	crypto := aes.New()
	key := os.Getenv("ERNEST_CRYPTO_KEY")
	cfg = ecc.NewConfig(os.Getenv("NATS_URI"))
	n = cfg.Nats()

	Given("^I setup a new environment name$", func() {
		serviceName = "aws" + strconv.Itoa(rand.Intn(9999999))
	})

	Given(`^I setup a new environment name "(.+?)"$`, func(name string) {
		serviceName = name
	})

	Given(`^I setup ernest with target "(.+?)"$`, func(target string) {
		if os.Getenv("CURRENT_INSTANCE") != "" {
			target = os.Getenv("CURRENT_INSTANCE")
		}

		ernest("target", target)
	})

	Given(`^I'm logged in as "(.+?)" / "(.+?)"$`, func(u, p string) {
		ernest("login", "--user", u, "--password", p)
	})

	Given(`^I'm logged in as "" / "(.+?)"$`, func(p string) {
		ernest("login", "--password", p)
	})

	Given(`^I'm logged in as "(.+?)" / ""$`, func(u string) {
		ernest("login", "--user", u)
	})

	When(`^I log in as "(.+?)" / "(.+?)"$`, func(u, p string) {
		ernest("login", "--user", u, "--password", p)
	})

	When(`^I run ernest with "(.+?)"$`, func(args string) {
		args = strings.Replace(args, "$(name)", serviceName, -1)
		cmdArgs := strings.Split(args, " ")

		ernest(cmdArgs...)
	})

	Then(`^[T|t]he output should contain "(.+?)"$`, func(needle string) {
		if strings.Contains(lastOutput, needle) == false {
			T.Errorf(`Last output string does not contain "` + needle + `": ` + "\n" + lastOutput)
		}
	})

	And(`^The output should contain "(.+?)"$`, func(needle string) {
		if strings.Contains(lastOutput, needle) == false {
			T.Errorf(`Last output string does not contain "` + needle + `": ` + "\n" + lastOutput)
		}
	})

	Then(`^The output should not contain "(.+?)"$`, func(needle string) {
		if strings.Contains(lastOutput, needle) == true {
			T.Errorf(`Last output string does contains "` + needle + `" but it shouldn't: ` + "\n" + lastOutput)
		}
	})

	Then(`^The output should contain regex "(.*)"$`, func(needle string) {
		r := regexp.MustCompile(needle)
		if r.MatchString(lastOutput) == false {
			T.Errorf(`Last output string does not contain regex "` + needle + `": ` + "\n" + lastOutput)
		}
	})

	And(`^[T|t]he output should contain regex "(.*)"$`, func(needle string) {
		r := regexp.MustCompile(needle)
		if r.MatchString(lastOutput) == false {
			T.Errorf(`Last output string does not contain regex "` + needle + `": ` + "\n" + lastOutput)
		}
	})

	Then(`^The output should not contain regex "(.*)"$`, func(needle string) {
		r := regexp.MustCompile(needle)
		if r.MatchString(lastOutput) == true {
			T.Errorf(`Last output string does contain regex "` + needle + `" but it shouldn't: ` + "\n" + lastOutput)
		}
	})

	And(`^The output should not contain regex "(.*)"$`, func(needle string) {
		r := regexp.MustCompile(needle)
		if r.MatchString(lastOutput) == true {
			T.Errorf(`Last output string does contain regex "` + needle + `" but it shouldn't: ` + "\n" + lastOutput)
		}
	})

	When(`^I logout$`, func() {
		ernest("logout")
	})

	When(`^I enter text "(.+?)"$`, func(input string) {
		cmd := exec.Command("ernest-cli", input)
		o, err := cmd.CombinedOutput()
		lastOutput = string(o)
		lastError = err
	})

	And(`^The user "(.+?)" does not exist$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
	})

	And(`^The project "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
	})

	And(`^The user "(.+?)" exists$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
		msg = []byte(`{"username":"` + user + `","password":"secret123"}`)
		_, _ = n.Request("user.set", msg, time.Second*3)
	})

	And(`^The project "(.+?)" exists$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + d + `"}`)
		_, _ = n.Request("datacenter.set", msg, time.Second*3)
	})

	And(`^I wait for "(.+?)" seconds$`, func(n int) {
		time.Sleep(time.Duration(n) * time.Second)
	})

	Then(`^The output line number "(.+?)" should contain "(.+?)"$`, func(number int, needle string) {
		lines := strings.Split(lastOutput, "\n")
		n := strconv.Itoa(number)

		if len(lines) < number {
			T.Errorf(`Last output has less than "` + n + `" lines : ` + "\n" + lastOutput)
			return
		}

		if strings.Contains(lines[number], needle) == false {
			T.Errorf(`Line "` + n + `" should contain "` + needle + `" but it doesn't: ` + "\n" + lastOutput)
		}

	})

	And(`^I force "(.+?)" to be on status "(.+?)"$`, func(environment string, status string) {
		_, _ = n.Request("build.set.status", []byte(`{"name":"`+environment+`","status":"`+status+`"}`), time.Second*3)
	})

	And(`^File "(.+?)" exists$`, func(filename string) {
		if f, err := os.Create(filename); err != nil {
			T.Errorf("Can't create file " + filename)
		} else {
			_ = f.Close()
		}
	})

	And(`^I start recording$`, func() {
		messages = map[string][][]byte{}
		sub, _ = n.Subscribe(">", func(m *nats.Msg) {
			messages[m.Subject] = append(messages[m.Subject], m.Data)
		})
	})

	And(`^I stop recording$`, func() {
		time.Sleep(time.Second * 1)
		_ = sub.Unsubscribe()
	})

	Then(`^all "(.+?)" messages should contain a field "(.+?)" with "(.+?)"$`, func(subject string, field string, val string) {
		val = strings.Replace(val, "$(name)", serviceName, -1)
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}
		for _, body := range messages[subject] {
			if strings.Contains(string(body), `"`+field+`":"`+val+`"`) == false && strings.Contains(string(body), `"`+field+`":`+val+``) == false {
				T.Errorf("Message " + subject + " does not contain the " + field + "/" + val + " pair")
				T.Errorf("Original message : " + (string(body)))
				return
			}
		}
	})

	Then(`^all "(.+?)" messages should contain an encrypted field "(.+?)" with "(.+?)"$`, func(subject string, field string, val string) {
		var msg map[string]interface{}
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}
		for _, body := range messages[subject] {
			err := json.Unmarshal(body, &msg)
			if err != nil {
				fmt.Println(err)
			}
			if value, ok := msg[field].(string); ok == false {
				fmt.Println(field)
				fmt.Println(msg)
				T.Errorf("Message " + subject + " does not contain the " + field + "/" + val + " pair\nOriginal message : " + (string(body)))
			} else {
				dec, _ := crypto.Decrypt(value, key)
				if val != dec {
					T.Errorf("Decrypted value " + dec + " for field " + field + " is not equal to " + val + "\nOriginal message : " + (string(body)))
				}
			}
		}
	})

	And(`^an event "(.+?)" should be called exactly "(.+?)" times$`, func(subject string, number int) {
		if len(messages[subject]) != number {
			T.Errorf("Message '"+subject+"' caught exactly %d times", len(messages[subject]))
			return
		}
	})
	And(`^I apply the definition "(.+?)"$`, func(def string) {
		if delay := os.Getenv("ERNEST_APPLY_DELAY"); delay != "" {
			if t, err := strconv.Atoi(delay); err == nil {
				println("\nWaiting " + delay + " seconds...")
				time.Sleep(time.Duration(t) * time.Second)
			}
		}
		def = getDefinitionPathAWS(def, serviceName)
		ernest("environment", "apply", def)
	})

	And(`^I apply the definition "(.+?)" with dry option$`, func(def string) {
		if delay := os.Getenv("ERNEST_APPLY_DELAY"); delay != "" {
			if t, err := strconv.Atoi(delay); err == nil {
				println("\nWaiting " + delay + " seconds...")
				time.Sleep(time.Duration(t) * time.Second)
			}
		}
		def = getDefinitionPathAWS(def, serviceName)
		ernest("environment", "apply", "--dry", def)
	})

	And(`^I apply "(.+?)" with "(.+?)"$`, func(def string, opts string) {
		if delay := os.Getenv("ERNEST_APPLY_DELAY"); delay != "" {
			if t, err := strconv.Atoi(delay); err == nil {
				println("\nWaiting " + delay + " seconds...")
				time.Sleep(time.Duration(t) * time.Second)
			}
		}
		def = getDefinitionPathAWS(def, serviceName)
		options := []string{"environment", "apply", def}
		options = append(options, strings.Split(opts, " ")...)
		ernest(options...)
	})

	And(`^all "(.+?)" messages should contain a credentials field "(.+?)" with "(.+?)"$`, func(subject string, field string, val string) {
		var msg map[string]interface{}
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}
		for _, body := range messages[subject] {
			err := json.Unmarshal(body, &msg)
			if err != nil {
				fmt.Println(err)
			}
			creds, ok := msg["_credentials"].(map[string]interface{})
			if !ok {
				T.Errorf("Message " + subject + " does not contain the '_credentials' field\nOriginal message : " + (string(body)))
			}

			if value, ok := creds[field].(string); ok == false {
				fmt.Println(field)
				fmt.Println(creds)
				T.Errorf("Message " + subject + " does not contain the " + field + "/" + val + " pair\nOriginal message : " + (string(body)))
			} else {
				if val != value {
					T.Errorf("Value " + value + " for field " + field + " is not equal to " + val + "\nOriginal message : " + (string(body)))
				}
			}
		}
	})

	And(`^all "(.+?)" messages should contain an encrypted credentials field "(.+?)" with "(.+?)"$`, func(subject string, field string, val string) {
		var msg map[string]interface{}
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}
		for _, body := range messages[subject] {
			err := json.Unmarshal(body, &msg)
			if err != nil {
				fmt.Println(err)
			}
			creds, ok := msg["_credentials"].(map[string]interface{})
			if !ok {
				T.Errorf("Message " + subject + " does not contain the '_credentials' field\nOriginal message : " + (string(body)))
			}

			if value, ok := creds[field].(string); ok == false {
				fmt.Println(field)
				fmt.Println(creds)
				T.Errorf("Message " + subject + " does not contain the " + field + "/" + val + " pair\nOriginal message : " + (string(body)))
			} else {
				dec, _ := crypto.Decrypt(value, key)
				if val != dec {
					T.Errorf("Decrypted value " + dec + " for field " + field + " is not equal to " + val + "\nOriginal message : " + (string(body)))
				}
			}
		}
	})

	And(`^message "(.+?)" number "(.+?)" should contain "(.+?)" as json field "(.+?)"$`, func(subject string, num int, val, key string) {
		val = strings.Replace(val, "$(name)", serviceName, -1)
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}

		value := gjson.Get(string(messages[subject][num]), key)

		switch value.Type {
		case gjson.String:
			if value.String() != val {
				T.Errorf("Message " + subject + " field " + key + " is equal to " + value.String() + " not " + val)
			}
		case gjson.Number:
			if strconv.FormatInt(value.Int(), 10) != val {
				T.Errorf("Message " + subject + " field " + key + " is equal to " + strconv.FormatInt(value.Int(), 10) + " not " + val)
			}
		}

	})

	And(`^message "(.+?)" number "(.+?)" should have an empty json field "(.+?)"$`, func(subject string, num int, key string) {
		if len(messages[subject]) == 0 {
			T.Errorf("No '" + subject + "' messages where caught")
			return
		}

		value := gjson.Get(string(messages[subject][num]), key).String()
		if value != "" {
			T.Errorf("Message " + subject + " field " + key + " is equal to " + value + " not empty")
		}
	})
	Before("@login", func() {
		// runs before every feature or scenario tagged with @login
	})

	When(`^I enter text "(.+?)"$`, func(input string) {
		cmd := exec.Command("ernest-cli", input)
		o, err := cmd.CombinedOutput()
		lastOutput = string(o)
		lastError = err
	})

	And(`^the user "(.+?)" does not exist$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
	})

	And(`^the project "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
	})

	And(`^The environment "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `"}`)
		_, _ = n.Request("environment.del", msg, time.Second*3)
	})

	And(`^the user "(.+?)" exists$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
		msg = []byte(`{"username":"` + user + `","password":"secret123"}`)
		_, _ = n.Request("user.set", msg, time.Second*3)
	})

	And(`^the project "(.+?)" exists$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + d + `"}`)
		_, _ = n.Request("datacenter.set", msg, time.Second*3)
	})

	And(`^I want you to create the tests for me$`, func() {
		fieldBlacklist := map[string]bool{
			"azure_tentant_id":      true,
			"azure_client_id":       true,
			"azure_subscription_id": true,
			"azure_client_secret":   true,
			"azure_tenant_id":       true,
			"service":               true,
			"name":                  true,
			"environment":           true,
			"id":                    true,
		}
		for subject, m := range messages {
			if string(subject[0]) != "_" && string(subject[0:8]) != "service." {
				times := strconv.Itoa(len(m))
				fmt.Println(`And an event "` + subject + `" should be called exactly "` + times + `" times`)
				for i, message := range m {
					var components map[string]interface{}
					if err := json.Unmarshal(message, &components); err != nil {
						log.Println(err.Error())
					} else {
						for field, value := range components {
							if val, ok := value.(string); ok && val != "" {
								if _, ok := fieldBlacklist[field]; ok == false {
									num := strconv.Itoa(i)
									fmt.Println(`And message "` + subject + `" number "` + num + `" should contain "` + field + `" as json field "` + val + `"`)
								}
							}
						}
					}
				}
			}
		}
	})

	And(`^The azure project "(.+?)" credentials should be "(.+?)", "(.+?)", "(.+?)", "(.+?)" and "(.+?)"$`, func(name, sID, cID, cSecret, tID, env string) {
		msg := []byte(`{"name":"` + name + `", "type":"azure"}`)
		res, _ := n.Request("datacenter.get", msg, time.Second*3)
		var d struct {
			Credentials struct {
				SubscriptionID string `json:"azure_subscription_id"`
				ClientID       string `json:"azure_client_id"`
				ClientSecret   string `json:"azure_client_secret"`
				TenantID       string `json:"azure_tenant_id"`
				Environment    string `json:"azure_environment"`
			} `json:"credentials"`
		}

		key := os.Getenv("ERNEST_CRYPTO_KEY")
		_ = json.Unmarshal(res.Data, &d)
		crypto := aes.New()
		subscriptionID, err := crypto.Decrypt(d.Credentials.SubscriptionID, key)
		if err != nil {
			log.Println(err)
		}
		clientID, err := crypto.Decrypt(d.Credentials.ClientID, key)
		if err != nil {
			log.Println(err)
		}
		clientSecret, err := crypto.Decrypt(d.Credentials.ClientSecret, key)
		if err != nil {
			log.Println(err)
		}
		tenantID, err := crypto.Decrypt(d.Credentials.TenantID, key)
		if err != nil {
			log.Println(err)
		}
		environment, err := crypto.Decrypt(d.Credentials.Environment, key)
		if err != nil {
			log.Println(err)
		}

		if subscriptionID != sID {
			T.Errorf(`Expected subscription id is "` + sID + `" but found ` + subscriptionID)
		}
		if clientID != cID {
			T.Errorf(`Expected client id is "` + cID + `" but found ` + clientID)
		}
		if clientSecret != cSecret {
			T.Errorf(`Expected client secret is "` + cSecret + `" but found ` + clientSecret)
		}
		if tenantID != tID {
			T.Errorf(`Expected tenant id is "` + tID + `" but found ` + tenantID)
		}
		if environment != env {
			T.Errorf(`Expected environment id is "` + env + `" but found ` + environment)
		}
	})

	And(`^The aws project "(.+?)" credentials should be "(.+?)" and "(.+?)"$`, func(name, token, secret string) {
		msg := []byte(`{"name":"` + name + `", "type":"aws"}`)
		res, _ := n.Request("datacenter.get", msg, time.Second*3)
		var d struct {
			Credentials struct {
				Token  string `json:"aws_access_key_id"`
				Secret string `json:"aws_secret_access_key"`
			} `json:"credentials"`
		}

		key := os.Getenv("ERNEST_CRYPTO_KEY")
		_ = json.Unmarshal(res.Data, &d)
		crypto := aes.New()
		tk, err := crypto.Decrypt(d.Credentials.Token, key)
		if err != nil {
			log.Println(err)
		}
		se, err := crypto.Decrypt(d.Credentials.Secret, key)
		if err != nil {
			log.Println(err)
		}

		if tk != token {
			T.Errorf(`Expected token is "` + token + `" but found ` + tk)
		}
		if se != secret {
			T.Errorf(`Expected secret is "` + secret + `" but found ` + se)
		}
	})

	And(`^I wait for "(.+?)" seconds$`, func(n int) {
		time.Sleep(time.Duration(n) * time.Millisecond)
	})

	Then(`^The output line number "(.+?)" should contain "(.+?)"$`, func(number int, needle string) {
		lines := strings.Split(lastOutput, "\n")
		n := strconv.Itoa(number)

		if len(lines) < number {
			T.Errorf(`Last output has less than "` + n + `" lines : ` + "\n" + lastOutput)
			return
		}

		if strings.Contains(lines[number], needle) == false {
			T.Errorf(`Line "` + n + `" should contain "` + needle + `" but it doesn't: ` + "\n" + lastOutput)
		}

	})

	And(`^I force "(.+?)" to be on status "(.+?)"$`, func(environment string, status string) {
		_, _ = n.Request("build.set.status", []byte(`{"name":"`+environment+`","status":"`+status+`"}`), time.Second*3)
	})

	And(`^File "(.+?)" exists$`, func(filename string) {
		if f, err := os.Create(filename); err != nil {
			T.Errorf("Can't create file " + filename)
		} else {
			_ = f.Close()
		}
	})

	And(`^File "(.+?)" does not exist$`, func(filename string) {
		_ = os.Remove(filename)
	})

	When(`^I verify with "(.+?)" / "(.+?)" / "(.+?)"$`, func(username, password, code string) {
		if code == "123456" {
			msg, _ := n.Request("user.get", []byte(`{"username":"`+username+`"}`), time.Second)

			var data map[string]interface{}
			err := json.Unmarshal(msg.Data, &data)
			if err != nil {
				log.Println(err)
			}

			t0 := int64(time.Now().Unix() / 30)
			cInt := dgoogauth.ComputeCode(data["mfa_secret"].(string), t0)
			code = fmt.Sprintf("%06d", cInt)
		}

		ernest("login", "--user", username, "--password", password, "--verification-code", code)
	})

	And(`^the user "(.+?)" exists with mfa enabled$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second)
		msg = []byte(`{"username": "` + user + `", "password": "secret123", "mfa": true}`)
		_, _ = n.Request("user.set", msg, time.Second)
	})

	And(`^I have a federation provider configured$`, func() {
		msg := []byte(`{"providers": [{"type": "local"}, {"type": "federation-fake"}]}`)
		_, _ = n.Request("config.set.authenticator", msg, time.Second)
	})
}

func getDefinitionPathAWS(def string, service string) string {
	finalPath := "/tmp/currentTest.yml"

	_, filename, _, _ := runtime.Caller(1)
	filePath := path.Join(path.Dir(filename), "..", "..", "definitions", def)

	input, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalln(err)
	}

	lines := strings.Split(string(input), "\n")
	var finalLines []string

	for _, line := range lines {
		if strings.Contains(line, "name: my_service") {
			finalLines = append(finalLines, "name: "+service)
		} else if strings.Contains(line, "project: r3-dc2") {
			finalLines = append(finalLines, "project: fakeaws")
		} else {
			finalLines = append(finalLines, line)
		}
	}
	output := strings.Join(finalLines, "\n")
	err = ioutil.WriteFile(finalPath, []byte(output), 0644)
	if err != nil {
		log.Fatalln(err)
	}

	return finalPath
}

func ernest(cmdArgs ...string) {
	lastOutput, lastError = run(20, "ernest-cli", cmdArgs...)
}

func run(timeout int, command string, args ...string) (string, error) {
	// instantiate new command
	cmd := exec.Command(command, args...)

	// get pipe to standard output
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Println("cmd.StdoutPipe() error: " + err.Error())
		return "cmd.StdoutPipe() error: " + err.Error(), err
	}

	// get pipe to standard output
	stderr, err := cmd.StderrPipe()
	if err != nil {
		log.Println("cmd.StderrPipe() error: " + err.Error())
		return "cmd.StderrPipe() error: " + err.Error(), err
	}

	// start process via command
	if err := cmd.Start(); err != nil {
		log.Println("cmd.Start() error: " + err.Error())
		return "cmd.Start() error: " + err.Error(), err
	}

	// setup a buffer to capture standard output
	var buf bytes.Buffer
	var ebuf bytes.Buffer

	// create a channel to capture any errors from wait
	done := make(chan error)
	go func() {
		if _, err := buf.ReadFrom(stdout); err != nil {
			panic("buf.Read(stdout) error: " + err.Error())
		}
		if _, err := ebuf.ReadFrom(stderr); err != nil {
			panic("buf.Read(stdout) error: " + err.Error())
		}
		done <- cmd.Wait()
	}()

	// block on select, and switch based on actions received
	select {
	case <-time.After(time.Duration(timeout) * time.Second):
		if err := cmd.Process.Kill(); err != nil {
			log.Println("failed to kill: " + err.Error())
			return "failed to kill: " + err.Error(), err
		}
		return "timeout reached, process killed", errors.New("Timeout reached, process killed")
	case err := <-done:
		if err != nil {
			close(done)
			log.Println("process done, with error : " + err.Error())
			fmt.Println(ebuf.String())
			return buf.String(), nil
		}
		// log.Println("process completed : " + buf.String())
		return buf.String(), nil
	}
}
