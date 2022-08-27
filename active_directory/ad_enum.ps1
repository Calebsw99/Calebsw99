#This script is for enumerating info from AD using LDAP



<#--------------------Building the query--------------------#>



#This queries for the general domain info
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

#Checks for the PDC hostname
$PDC = ($domainObj.PdcRoleOwner).Name

#Then appends the PDC into the SearchString variable
$SearchString = "LDAP://"
$SearchString += $PDC + "/"

#Next it will form the distinguished name by parsing through the $domainObj variable
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName


#At this point, we can use the $SearchString variable to query the DC
#SearchString = "LDAP://DC01.corp.com/DC=corp,DC=com" at this point


#The DirectorySearcher class lets you query AD using LDAP
#Here we instantiate the DirecorySearcher class and specify a SearchRoot (Where we want to start searching)
#LDAP is the only native Active Directory Service Interfaces (ADSI) that supports directory searching
$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

#The DirectoryEntity class encapsulates a node or object and returns it in your query
$objDomain = New-Object System.DirectoryServices.DirectoryEntry

#When there are not any other arguments, SearchRoot will grab everything in the hierarchy specified
$Searcher.SearchRoot = $objDomain




<#-------------------Pick your poison--------------------#>


#From here, we can filter what we want to see
#samAccountType can pull up all kinds of account types.
#https://docs.microsoft.com/en-us/windows/win32/adschema/a-samaccounttype?redirectedfrom=MSDN
#convert the Hex to Decimal before searching
#$Searcher.filter="samAccountType=805306368" <#search for all normal user accounts#>
#$Searcher.filter="name=Jeff_Admin" <#search for info on Jeff_Admin#>


$Searcher.filter=
$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop
    }
    
    Write-Host "------------------------"
}



<#-------------------Nested Groups--------------------#>



<# Lists all groups
$Searcher.filter="(objectClass=Group)"
$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    $obj.Properties.name
}
#>

<# Lists all members of a particular group
$Searcher.filter="(name=Secret_Group)"
$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    $obj.Properties.member
}
#>



<#-------------------Service Principal Names--------------------#>



<# Lists all HTTP service accounts
$Searcher.filter="serviceprincipalname=*http*"
$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop
    }
    
    Write-Host "------------------------"
}
#>
<# This will usually have the hostname, which we can use nslookup to find and navigate to #>