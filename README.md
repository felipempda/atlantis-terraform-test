# Terraform project using Atlantis

Simple terraform project that creates an array of AWS SSM parameters (because they are very fast to create) using Atlantis.

Atlantis is an application for automating Terraform via pull requests. 
Read more about it [here](https://www.runatlantis.io).

## Testing locally

You can run it locally for testing your terraform project. You will need to:

- Generate GitHub Token
- Install atlantis, terraform, ngrok
- Run ngrok to get a publicly accessible hostname

![ngrok](/images/01-ngrok.PNG)

Leave it running like that and open a new window to continue:

- Store ngrok URL in a variable:
```bash
URL=http://362f-174-91-254-230.ngrok.io
```
- Create a local secret

```bash
SECRET=$(echo $RANDOM | md5sum | head -c 20; echo;)
echo $SECRET
```

- Create a Github Webhook using ngrok URL/events and the secret:

![webhook](/images/02a-webhook.PNG)

Select the following individual events for the webhook:
    - Issue comments
    - Pull request reviews
    - Pull requests
    - Pushes

- Start Atlantis

```bash
# expose provider configuration as environment variables:
# in the case of AWS:
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=...

# expose your repo configuration
URL="http://362f-174-91-254-230.ngrok.io"
YOUR_USERNAME="felipempda"
YOUR_GIT_HOST="github.com"
YOUR_REPO="atlantis-terraform-test"
REPO_ALLOWLIST="$YOUR_GIT_HOST/$YOUR_USERNAME/$YOUR_REPO"
echo $REPO_ALLOWLIST
#ex :github.com/felipempda/atlantis-terraform-test

#run it
atlantis server \
--atlantis-url="$URL" \
--gh-user="$USERNAME" \
--gh-token="$TOKEN" \
--gh-webhook-secret="$SECRET" \
--repo-allowlist="$REPO_ALLOWLIST"
```

Atlantis will listen on port 4141 locally and wait for calls from your webhook:

![atlantislocal](/images/02b-atlantis.PNG)

## Pull Request

Now you can amuse yourself with Pull Requests.
Create a new branch, change the code, create a Pull Request, etc.
Example of a [pull request](https://github.com/felipempda/atlantis-terraform-test/pull/1).

Inside the PR you can type various `atlantis` commands that will trigger the Webhook > Ngork > Atlantis chain. For example:

You can type `atlantis plan` and a very nicely formatted plan will be generated:

![altlantisplana](/images/03-atlantisplana.PNG)

![altlantisplanb](/images/04-atlantisplanb.PNG)

At this time you can take the time to review your plan, maybe even fix the Pull Request if things aren't as you expect.

This is a very nice feature for reviewers as well.

Once you are OK with your PR you can type `atlantis apply` to deploy your changes:

![altlantisapply](/images/05-atlantisapply.PNG)



## Using in production

You can deploy it as a Kubernetes Application following several guides [here](https://www.runatlantis.io/docs/deployment.html#routing).