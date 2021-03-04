# DNS Records API Challenge

This is an API with 2 endpoints:

**API Endpoint #1**

Endpoint #1 creates a DNS record and its associated hostnames. This endpoint should accept an IPv4 IP address and a list of hostnames. The response should return the ID of the DNS record created. It can receive the IP address and the list of hostnames in JSON format as the following:
```json
{
    "dns_records": {
        "ip": "1.1.1.1",
        "hostnames_attributes": [
            { "hostname": "lorem.com" },
            { "hostname": "ipsum.com" },
            { "hostname": "dolor.com" },
            { "hostname": "amet.com" }
        ]
    }
}
```
It cannot receive more than one DNS record per request. This endpoint is a *post* request on the following route:

```
/dns_records
```
It is possible to test this API Endpoint by using cURL as follows:
```bash
curl --header "Content-Type: application/json" --request POST --data '{"dns_records": {"ip": "1.1.1.1","hostnames_attributes": [{ "hostname": "lorem.com" },{ "hostname": "ipsum.com" },{ "hostname": "dolor.com" },{ "hostname": "amet.com" }]}}' http://localhost:3000/dns_records
```
**API Endpoint #2**

Endpoint #2 returns DNS records and their hostnames. This second endpoint accepts query with one required parameter: *page*.
The query can be send in JSON format as the following:

```json
{
    "hostnames": {
        "should_have": ["ipsum.com" , "dolor.com"],
        "shouldnt_have": ["sit.com"]
    },
    "page": 1
}
```
The JSON query should be sent in the body of the request. The endpoint is a *get* request with the following route:

```
/dns_records
```
It is possible to test this API Endpoint by using cURL as follows:
```bash
curl --header "Content-Type: application/json" --request GET --data '{"hostnames": {"should_have": ["ipsum.com" , "dolor.com"],"shouldnt_have": ["sit.com"]},"page": 1}' http://localhost:3000/dns_records
```

It is interesting to say that the examples provided on the challenge description are going to be seeded as the DB is created and migrated.
## Building and Running

Docker will be needed for this project to run. Please, get installation informations from [this page](https://docs.docker.com/engine/install/).

To build the project, use the following comand:

```bash
docker build -t dns_records
```

To run tests, use the following command:
```bash
docker run -it --rm demo rspec
```
To get the API up and running, use the following command:
```bash
docker run -p 3000:3000 -itP dns_records
```
