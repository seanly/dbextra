# elasticsearch

## set password

```
bin/elasticsearch-setup-passwords interactive
```

```
curl -XPOST -u elastic "localhost:9200/_security/user/elastic/_password" -H 'Content-Type: application/json' -d'{"password" : "admin123"}'
```

curl -XPOST -u elastic:admin123 "localhost:9200/_security/user/kibana_system/_password" -H 'Content-Type: application/json' -d'{"password" : "test123"}'