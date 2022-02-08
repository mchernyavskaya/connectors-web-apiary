# connector-web-api
External Connector API is an API that stands between the EXternal Connector implementation and the Enterprise Search (Workplace Search). It is pull-based, meaning that there will be only GET methods in it, which will allow Workplace Search to pull content based on the schedule that Workplace Search implements and supports.

## Version: 1.0

**License:** [MIT](https://github.com/apiaryio/connector-web-api/blob/master/LICENSE)

### Security
**ApiKeyAuth**  

|apiKey|*API Key*|
|---|---|
|In|header|
|Name|Authorization|

**OAuth2**  

|oauth2|*OAuth 2.0*|
|---|---|
|Flow|accessCode|
|Authorization URL|<https://example.com/oauth/authorize>|
|Token URL|<https://example.com/oauth/token>|

### /

#### GET
##### Summary

Returns the configuration and abilities of the connector.

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | A successful response. | [ConnectorConfigurationResponse](#connectorconfigurationresponse) |

### /status

#### GET
##### Summary

This endpoint is supposed to show both the status of the external connector, as well as the status of a third-party content provider.

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | A JSON object describing the general service status and that of a third party content provider.<br><br>**Example** (*status*):<br><pre>UP</pre><br><br>**Example** (*statusMessage*):<br><pre>I am up and running</pre><br><br>**Example** (*contentProviderStatus*):<br><pre>DOWN</pre><br><br>**Example** (*contentProviderStatusMessage*):<br><pre>Too many requests</pre><br><br>**Example** (*contentProviderStatusCode*):<br><pre>429</pre> | [ServiceStatusResponse](#servicestatusresponse) |

### /documents

#### POST
##### Summary

Provide a list of documents to index based on the input parameters.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
|  |  |  | No | [DocumentRequest](#documentrequest) |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | A list of documents to index.<br><br>**Example** (*withoutPermissions*):<br><pre>{<br>  "results": [<br>    {<br>      "id": "so7mgSrdgRq+RJe0",<br>      "publishedDate": "2022-02-03T13:46:55.648Z",<br>      "type": "page",<br>      "title": "Example Document",<br>      "url": "https://www.example.com/somePath/example",<br>      "body": "Example Domain\nThis domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission."<br>    },<br>    {<br>      "download": [<br>        "attachment_id_1",<br>        "attachment_id_2"<br>      ]<br>    }<br>  ]<br>}</pre><br><br>**Example** (*withPermissions*):<br><pre>{<br>  "results": [<br>    {<br>      "id": "so7mgSrdgRq+RJe0",<br>      "publishedDate": "2022-02-03T13:46:55.648Z",<br>      "type": "page",<br>      "title": "Example Document",<br>      "url": "https://www.example.com/somePath/example",<br>      "body": "Example Domain\nThis domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission.",<br>      "allow_permissions": [<br>        "john.doe@gmail.com"<br>      ],<br>      "deny_permissions": [<br>        "jane.doe@gmail.com"<br>      ]<br>    }<br>  ],<br>  "errors": []<br>}</pre><br><br>**Example** (*freeForm*):<br><pre>{<br>  "results": [<br>    {<br>      "authorLastName": "Jane",<br>      "authorFirstName": "Austen",<br>      "isbn": "ISBN12345",<br>      "publisher": "Penguin Books",<br>      "publishYear": 1998,<br>      "country": "UK",<br>      "title": "Pride and Prejudice",<br>      "rating": 5<br>    }<br>  ],<br>  "errors": []<br>}</pre> | [DocumentListResponse](#documentlistresponse) |
| 400 | A generic error response.<br><br>**Example** (*results*):<br><pre>[]</pre><br><br>**Example** (*errors*):<br><pre>[<br>  {<br>    "code": "CLIENT_CONNECT_FAILED",<br>    "message": "I am a big fat error. So there. Oh yeah, and the client connection failed."<br>  }<br>]</pre> | [DocumentListResponse](#documentlistresponse) |
| 401 | Not authorized to use this resource. |  |
| 403 | The access to this resource is forbidden. |  |
| 500 | Internal server error. |  |

### /documents/{id}

#### GET
##### Summary

Get a single document by its unique ID.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| id | path | The unique ID by which a document can be identified. | Yes | string |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | A document in its JSON form.<br><br>**Example** (*withAttachments*):<br><pre>{<br>  "results": [<br>    {<br>      "id": "so7mgSrdgRq+RJe0",<br>      "publishedDate": "2022-02-03T13:46:55.648Z",<br>      "type": "page",<br>      "title": "Example Document",<br>      "url": "https://www.example.com/somePath/example",<br>      "body": "Example Domain\nThis domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission."<br>    },<br>    {<br>      "download": [<br>        "attachment_id_1",<br>        "attachment_id_2"<br>      ]<br>    }<br>  ]<br>}</pre> | [SingleDocumentResponse](#singledocumentresponse) |
| 400 | A generic error response.<br><br>**Example** (*result*):<br><pre>{}</pre><br><br>**Example** (*errors*):<br><pre>[<br>  {<br>    "code": "CLIENT_CONNECT_FAILED",<br>    "message": "I am a big fat error. So there. Oh yeah, and the client connection failed."<br>  }<br>]</pre> | [SingleDocumentResponse](#singledocumentresponse) |
| 401 | Not authorized to use this resource. |  |
| 403 | The access to this resource is forbidden. |  |
| 500 | Internal server error. |  |

### /deleted

#### POST
##### Summary

Checks the list of document IDs and returns those that no longer exist in the source.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
|  |  |  | No | [DeletedIdsRequest](#deletedidsrequest) |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | The ids of deleted documents.<br><br>**Example** (*results*):<br><pre>[<br>  "abcd"<br>]</pre><br><br>**Example** (*errors*):<br><pre>[]</pre> | [DeletedIdsResponse](#deletedidsresponse) |
| 400 | A generic error response.<br><br>**Example** (*results*):<br><pre>{}</pre><br><br>**Example** (*errors*):<br><pre>[<br>  {<br>    "code": "CLIENT_CONNECT_FAILED",<br>    "message": "I am a big fat error. So there. Oh yeah, and the client connection failed."<br>  }<br>]</pre> | [DeletedIdsResponse](#deletedidsresponse) |
| 401 | Not authorized to use this resource. |  |
| 403 | The access to this resource is forbidden. |  |
| 500 | Internal server error. |  |

### /download

#### POST
##### Summary

Get a binary file using the data received in downloads for a document.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
|  |  |  | No | [FileRequest](#filerequest) |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | Binary content. | [FileResponse](#fileresponse) |
| 400 | Errors list. | [ErrorResponse](#errorresponse) |
| 401 | Not authorized to use this resource. |  |
| 403 | The access to this resource is forbidden. |  |
| 500 | Internal server error. |  |

### /schema

#### GET
##### Summary

Returns a schema definition for a connector.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | Connector mappings. It's a list of fields and data types for a document object.<br><br>**Example** (*schema*):<br><pre>{<br>  "container": "text",<br>  "extension": "text",<br>  "created_at": "date",<br>  "project": "text",<br>  "description": "text",<br>  "title": "text",<br>  "body": "text",<br>  "type": "text",<br>  "slug": "text",<br>  "assigned_to": "text",<br>  "comments": "text",<br>  "issue": "text",<br>  "priority": "text",<br>  "created_by": "text",<br>  "url": "text",<br>  "size": "number",<br>  "mime_type": "text",<br>  "updated_by": "text",<br>  "status": "text"<br>}</pre><br><br>**Example** (*errors*):<br><pre>[]</pre> | [SchemaResponse](#schemaresponse) |
| 400 | Errors list. | [ErrorResponse](#errorresponse) |
| 401 | Not authorized to use this resource. |  |
| 403 | The access to this resource is forbidden. |  |
| 500 | Internal server error. |  |

### Models

#### ServiceStatusResponse

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| status | [ServiceStatusEnum](#servicestatusenum) | Whether the external connector service itself is UP or DOWN. | Yes |
| statusMessage | string | A message explaining the status (if needed). Extra information about the application state. | No |
| contentProviderStatus | [ServiceStatusEnum](#servicestatusenum) | Whether the third-party service that provides the content is UP or DOWN. | No |
| contentProviderStatusMessage | string | A message explaining the status (if needed). Extra information about the service state. | No |
| contentProviderStatusCode | string | A status code from the content provider that explains its status data. May be an HTTP status; or can be something internal for the service. | No |

#### ConnectorConfigurationResponse

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| description | string |  | No |

**Example**
<pre>{
  "description": "You know, for pulling content for ingestion. Burp."
}</pre>

#### ServiceStatusEnum

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ServiceStatusEnum | string |  |  |

#### DocumentListResponse

List of documents, exposed for ingestion.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| results | [ [Document](#document) ] |  | No |
| errors | [ [Error](#error) ] |  | No |

#### SingleDocumentResponse

A single document, exposed for ingestion.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| result | [Document](#document) |  | No |
| errors | [ [Error](#error) ] |  | No |

#### Document

A document definition.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| id | string | A unique ID of the document. | Yes |

#### DocumentRequest

A document request.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| modifiedSince | string | The modification date to be used as a lower limit for getting the documents. If omitted, should get the full list of documents available. | No |
| timeoutMs | integer | Timeout in milliseconds for the operation to end. On timing out, the client should either retry, or increase the timeout. default: 5000 | No |

#### DeletedIdsRequest

JSON list of IDs to check for existence.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ids | [ string ] | JSON list of IDs to check for existence. | No |

#### DeletedIdsResponse

IDs that no longer exist provided in a list of results, or a list of errors.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| results | [ string ] | IDs that no longer exist in a third party content source. | No |
| errors | [ [Error](#error) ] |  | No |

#### FileRequest

Whatever the connector sent in a download field on the document (not necessaryly JSON).

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| FileRequest | string | Whatever the connector sent in a download field on the document (not necessaryly JSON). |  |

#### FileResponse

Streams binary file content to the client (as multipart/form-data).

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| FileResponse | string | Streams binary file content to the client (as multipart/form-data). |  |

#### Error

An error with a code and error message. Both are strings to allow for more flexibility.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| code | string |  | Yes |
| message | string |  | Yes |

#### ErrorResponse

A list of errors.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| errors | [ [Error](#error) ] |  | No |

#### SchemaResponse

A list of mappings for documents that connector provides for ingestion, or a list of errors.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| schema | [SchemaObject](#schemaobject) |  | No |
| errors | [ [Error](#error) ] |  | No |

#### SchemaObject

A list of mappings for documents that connector provides for ingestion.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
