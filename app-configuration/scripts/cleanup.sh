if [ -z "$resourceGroupName" ]
then
  echo "Empty resourceGroupName"
  exit
fi

echo "Delete resource group $resourceGroupName ..."
az group delete --name $resourceGroupName --yes --no-wait