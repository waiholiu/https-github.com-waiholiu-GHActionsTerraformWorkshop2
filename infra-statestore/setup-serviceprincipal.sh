# need to be done per branch



# Define variable for display name
DISPLAY_NAME="<uniquename>-<branch>-oidc"
# Define variables for name and subject
FEDERATED_IDENTITY_NAME="<uniquename>-<branch>-federated-identity"
FEDERATED_IDENTITY_SUBJECT="repo:<account>/<reponame>:ref:refs/heads/<branch>"


AZURE_TENANT=$(az account show -o tsv --query tenantId)
SUBSCRIPTION_ID=$(az account show -o tsv --query id)



# create a service principal
APP_ID=$(az ad app create --display-name $DISPLAY_NAME --query appId -o tsv)

az ad sp create --id $APP_ID --query appId -o tsv

OBJECT_ID=$(az ad app show --id $APP_ID --query id -o tsv)



# create a federated identity to allow access 
az rest --method POST --uri "https://graph.microsoft.com/beta/applications/$OBJECT_ID/federatedIdentityCredentials" \
--body "{\"name\":\"$FEDERATED_IDENTITY_NAME\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"$FEDERATED_IDENTITY_SUBJECT\",\"description\":\"GitHub\",\"audiences\":[\"api://AzureADTokenExchange\"]}" \
--headers "Content-Type=application/json"

# give the service principal access to the subscription
az role assignment create --assignee $APP_ID --role contributor --scope subscriptions/$SUBSCRIPTION_ID
az role assignment create --assignee $APP_ID --role 'User Access Administrator' --scope subscriptions/$SUBSCRIPTION_ID



# take this and put in github secrets


# AZURE_SUBSCRIPTION_ID
echo $SUBSCRIPTION_ID
# AZURE_TENANT_ID
echo $AZURE_TENANT
# AZURE_CLIENT_ID
echo $APP_ID
