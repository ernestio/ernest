package aws

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
	"runtime"
	"strconv"
	"strings"
	"time"

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

	Given("^I setup a new service name$", func() {
		serviceName = "aws" + strconv.Itoa(rand.Intn(9999999))
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

	When(`^I run ernest with "(.+?)"$`, func(args string) {
		cmdArgs := strings.Split(args, " ")
		ernest(cmdArgs...)
	})

	Then(`^The output should contain "(.+?)"$`, func(needle string) {
		if strings.Contains(lastOutput, needle) == false {
			T.Errorf(`Last output string does not contain "` + needle + `": ` + "\n" + lastOutput)
		}
	})

	Then(`^The output should not contain "(.+?)"$`, func(needle string) {
		if strings.Contains(lastOutput, needle) == true {
			T.Errorf(`Last output string does contains "` + needle + `" but it shouldn't: ` + "\n" + lastOutput)
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

	And(`^The group "(.+?)" does not exist$`, func(group string) {
		msg := []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.del", msg, time.Second*3)
	})

	And(`^The user "(.+?)" does not exist$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
	})

	And(`^The datacenter "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
	})

	And(`^The service "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("service.del", msg, time.Second*3)
	})

	And(`^The group "(.+?)" exists$`, func(group string) {
		msg := []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.set", msg, time.Second*3)
	})

	And(`^The user "(.+?)" exists$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
		msg = []byte(`{"username":"` + user + `","password":"pwd"}`)
		_, _ = n.Request("user.set", msg, time.Second*3)
	})

	And(`^The datacenter "(.+?)" exists$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + d + `"}`)
		_, _ = n.Request("datacenter.set", msg, time.Second*3)
	})

	And(`^I wait for "(.+?)" seconds$`, func(n int) {
		time.Sleep(time.Duration(n) * time.Millisecond)
	})

	Then(`^The output users table should contain "(.+?)" assigned to "(.+?)" group$`, func(user string, group string) {
		lines := strings.Split(lastOutput, "\n")
		for _, l := range lines {
			if strings.Contains(l, user) {
				if !strings.Contains(l, "| "+group) {
					T.Errorf(`User doesn't seem to belong to specified group: \n` + l)
				}
			}
		}
	})

	Then(`^The output datacenters table should contain "(.+?)" assigned to "(.+?)" group$`, func(datacenter string, group string) {
		lines := strings.Split(lastOutput, "\n")
		for _, l := range lines {
			if strings.Contains(l, datacenter) {
				if !strings.Contains(l, "| "+group) {
					T.Errorf(`Datacenter doesn't seem to belong to specified group: \n` + l)
				}
			}
		}
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

	And(`^I force "(.+?)" to be on status "(.+?)"$`, func(service string, status string) {
		_, _ = n.Request("service.set", []byte(`{"name":"`+service+`","status":"`+status+`"}`), time.Second*3)
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
		_ = sub.Unsubscribe()
		time.Sleep(time.Second * 5)
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
		ernest("service", "apply", def)
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

	And(`^the group "(.+?)" does not exist$`, func(group string) {
		msg := []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.del", msg, time.Second*3)
	})

	And(`^the user "(.+?)" does not exist$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
	})

	And(`^the datacenter "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
	})

	And(`^The service "(.+?)" does not exist$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("service.del", msg, time.Second*3)
	})

	And(`^the group "(.+?)" exists$`, func(group string) {
		msg := []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + group + `"}`)
		_, _ = n.Request("group.set", msg, time.Second*3)
	})

	And(`^the user "(.+?)" exists$`, func(user string) {
		msg := []byte(`{"username":"` + user + `"}`)
		_, _ = n.Request("user.del", msg, time.Second*3)
		msg = []byte(`{"username":"` + user + `","password":"pwd"}`)
		_, _ = n.Request("user.set", msg, time.Second*3)
	})

	And(`^the datacenter "(.+?)" exists$`, func(d string) {
		msg := []byte(`{"name":"` + d + `", "type":"aws"}`)
		_, _ = n.Request("datacenter.del", msg, time.Second*3)
		msg = []byte(`{"name":"` + d + `"}`)
		_, _ = n.Request("datacenter.set", msg, time.Second*3)
	})

	And(`^The aws datacenter "(.+?)" credentials should be "(.+?)" and "(.+?)"$`, func(name, token, secret string) {
		msg := []byte(`{"name":"` + name + `", "type":"aws"}`)
		res, _ := n.Request("datacenter.get", msg, time.Second*3)
		var d struct {
			Token  string `json:"aws_access_key_id"`
			Secret string `json:"aws_secret_access_key"`
		}

		key := os.Getenv("ERNEST_CRYPTO_KEY")
		_ = json.Unmarshal(res.Data, &d)
		crypto := aes.New()
		tk, err := crypto.Decrypt(d.Token, key)
		if err != nil {
			log.Println(err)
		}
		se, err := crypto.Decrypt(d.Secret, key)
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

	Then(`^The output users table should contain "(.+?)" assigned to "(.+?)" group$`, func(user string, group string) {
		lines := strings.Split(lastOutput, "\n")
		for _, l := range lines {
			if strings.Contains(l, user) {
				if !strings.Contains(l, "| "+group) {
					T.Errorf(`User doesn't seem to belong to specified group: \n` + l)
				}
			}
		}
	})

	Then(`^The output datacenters table should contain "(.+?)" assigned to "(.+?)" group$`, func(datacenter string, group string) {
		lines := strings.Split(lastOutput, "\n")
		for _, l := range lines {
			if strings.Contains(l, datacenter) {
				if !strings.Contains(l, "| "+group) {
					T.Errorf(`Datacenter doesn't seem to belong to specified group: \n` + l)
				}
			}
		}
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

	And(`^I force "(.+?)" to be on status "(.+?)"$`, func(service string, status string) {
		_, _ = n.Request("service.set", []byte(`{"name":"`+service+`","status":"`+status+`"}`), time.Second*3)
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
		} else if strings.Contains(line, "datacenter: r3-dc2") {
			finalLines = append(finalLines, "datacenter: fakeaws")
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

	// start process via command
	if err := cmd.Start(); err != nil {
		log.Println("cmd.Start() error: " + err.Error())
		return "cmd.Start() error: " + err.Error(), err
	}

	// setup a buffer to capture standard output
	var buf bytes.Buffer

	// create a channel to capture any errors from wait
	done := make(chan error)
	go func() {
		if _, err := buf.ReadFrom(stdout); err != nil {
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
			return buf.String(), nil
		}
		// log.Println("process completed : " + buf.String())
		return buf.String(), nil
	}
}
