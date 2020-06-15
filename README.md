# MsdOdata

Ruby gem for accessing Microsoft Dynamics AX via their ODATA protocol

For more info, check Microsoft Odata [Documentation](https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/odata)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'msd_odata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install msd_odata

## Requirements

This gem has been tested on ruby 2.4.5

## Dependencies
Gems:

1. [faraday](https://github.com/lostisland/faraday)
2. [json](https://github.com/flori/json)

## Usage
### Access Token retrieving:

Before you make any requests, you will need to fetch the access token using your credentials and your resource url that you got from Microsoft Dynamics

```ruby
options = {'client_id'=>'63294ZXR-4030-E511-6595-7C36E5ZUDD60', 'client_secret'=>'53291AAB-9090-E311-6565-6C3BE5ZUDD60', 'grant_type'=>'client_credentials', 'resource'=>'https://example.sandbox.ax.dynamics.com'}
tenant_id = '74294ZXR-5030-A511-9898-8C36E5ZUDD60'
token_response = MsdOdata::Auth.new(tenant_id, options).token
# => {:status=>200,:response_body=> {"token_type"=>"Bearer" ..., "access_token": "MjktNDc2MC05NDdlLTljYmYyMjMzNjdhNiIsInJvbGVz ..."}}
```
Note: Before using the retrieved access token in further requests you will need to put ```Bearer ``` before the token itself, for example:
```ruby
token = "Bearer MjktNDc2MC05NDdlLTljYmYyMjMzNjdhNiIsInJvbGVz..."
```

## CRUD actions
Before making any CRUD action you will need a `token` from the previous step, and a `base_url` which is called `resource` in MSD credentials.

### Create a resource
```ruby
# Payload attributes.
attrs = {
  "OrderingCustomerAccountNumber" => '1',
  "InvoiceType" => "Invoice"
}

# Creating entity object, you can pass any entity name as the first argument.
entity = MsdOdata::Entity.new(:SalesOrderHeaders, attrs)

# Creating service object.
service = MsdOdata::Service.new(token, base_url, entity)

# POST request to base_url/data/SalesOrderHeaders with the payload you provided.
response = service.create
# => {:status=>201, :response_body=>{"@odata.context"=>"https://xxxxx.sandbox.ax.dynamics.com/data/$metadata#SalesOrderHeaders/$entity", "@odata.etag"=>"W/\"TQ4MjAwMzxOTUyMTQ4MDswLD....\"", "dataAreaId"=>"usmf", "SalesOrderNumber"=>"001357", "SalesUnitId"=>"", "OrderTotalTaxAmount"=>0, "AreTotalsCalculated"=>"No"........ }}
```

### Update a resource
```ruby
attrs = {
  # URL params to build the url.
  "url_params" => {
    "dataAreaId" => "usmf",
    "CustomerAccount" => "DE-001",
  },
  # Request payload. (attributes to be updated)
  "body" => {
    "Name" => "Hb New Brand",
  }
}

entity = MsdOdata::Entity.new(:Customers, attrs)
service = MsdOdata::Service.new(token, base_url, entity)

# PATCH request to base_url/data/Customers(dataAreaId='usmf',CustomerAccount='DE-001')
service.update
# => {:status=>204, :response_body=>false}
```

### Delete a resource
```ruby
attrs = {
  # URL params to build the url.
  "url_params" => {
    "dataAreaId" => "usmf",
    "InventoryLotId" => "013247",
  }
}

entity = MsdOdata::Entity.new(:SalesOrderLines, attrs)
service = MsdOdata::Service.new(token, base_url, entity)

# DELETE request to base_url/data/SalesOrderLines(dataAreaId='usmf',InventoryLotId='013247')
service.delete
# => {:status=>204, :response_body=>false}
```

### Query a resource
To query a resource you will use `entity` class methods that will help you to build a query based on [OData system query options](https://msdn.microsoft.com/en-us/library/gg309461.aspx).

#### Query operators
Supported operators are: eq, ne, gt, ge, lt, le, and, or, not.
```ruby
entity = MsdOdata::Entity.new(:Customers)
entity.where(entity['PartyType'].eq('Organization')) # => PartyType equal 'Organization'
entity.where(entity['CreditLimit'].gt(10000)) # => CreditLimit greater than 10,000

# You can also pass the expression as a string to where function, with a default 'and' if you pass multiple expressions.
entity.where("PartyType eq 'Organization'", 'CreditLimit gt 10000')
```

You can use 'not', 'or', 'and' operators like:
```ruby
entity.where.not(exp) # not (expression)
entity.where(exp).not(exp) # (exp1) and not (exp2)
entity.where(exp).or(exp).and(exp) # exp1 or exp2 and exp3
```

#### Other query options
```ruby
entity = MsdOdata::Entity.new(:AccountSet)

# Select what fields to retrieve
entity.select('CustomerAccount', 'Name')

# Fetch a related resource to the entity
entity.expand('opportunity_customer_accounts')

# Limit the result set to a specific number of records
entity.limit(20)

# Order the result set by a field or multiple fields.
entity.order_by('CustomerAccount')

# Skip a number of records in the result set
entity.skip(100)
```

## Logger

By default, logging is enabled and directed at STDOUT.

## Contributing

1. Fork it
2. Create your feature branch (```git checkout -b my-new-feature```)
3. Commit your changes (```git commit -am 'Add some feature'```)
4. Push to the branch (```git push origin my-new-feature```)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
