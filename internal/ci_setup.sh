$GOBIN/natsc request -s $NATS_URI -t 5 -r 99 'group.set' '{"id":"1","name": "ci_admin"}'
$GOBIN/natsc request -s $NATS_URI -t 5 -r 99 'user.set' '{"group_id": 1, "username": "ci_admin", "password": "secret123", "admin":true}'
ernest-cli target $CURRENT_INSTANCE
ernest-cli login --user ci_admin --password secret123
ernest-cli user create usr secret123
ernest-cli group create test
ernest-cli group add-user usr test
ernest-cli login --user usr --password secret123
ernest-cli datacenter create aws fakeaws --region fake --secret_access_key fake_up_to_16_characters --access_key_id up_to_16_characters_secret --fake
ernest-cli datacenter create vcloud fakevcloud -org test -user fakeuser -password test123 -public-network test-nw -vcloud-url https://vcloud.net --fake
ernest-cli datacenter create azure --subscription_id subid --client_id cliid --client_secret clisec --region westus --tenant_id tenid --environment public --fake fakeazure
