# activiti-cloud-full-example

![Version: 0.0.0+REPLACEME](https://img.shields.io/badge/Version-0.0.0+REPLACEME-informational?style=flat-square)

A Helm chart for Activiti Cloud Full Example

## Source Code

* <https://github.com/Activiti/activiti-cloud-full-chart>

## Requirements

Kubernetes: `>= 1.9.0 < 1.22.0`

| Repository | Name | Version |
|------------|------|---------|
| https://activiti.github.io/activiti-cloud-helm-charts/ | activiti-cloud-connector | 7.1.990 |
| https://activiti.github.io/activiti-cloud-helm-charts/ | activiti-cloud-query | 7.1.990 |
| https://activiti.github.io/activiti-cloud-helm-charts/ | common | 7.1.3 |
| https://activiti.github.io/activiti-cloud-helm-charts/ | runtime-bundle | 7.1.990 |
| https://activiti.github.io/activiti-cloud-helm-charts/ | runtime-bundle | 7.1.990 |
| https://charts.bitnami.com/bitnami | postgresql | 8.9.5 |
| https://charts.bitnami.com/bitnami | rabbitmq | 7.8.0 |
| https://codecentric.github.io/helm-charts | keycloak | 8.3.0 |
| https://kubernetes-charts.alfresco.com/stable | alfresco-adf-app | 7.1.0-M11 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activiti-cloud-connector.enabled | bool | `true` |  |
| activiti-cloud-connector.extraEnv | string | `"- name: SERVER_SERVLET_CONTEXTPATH\n  value: \"{{ tpl .Values.ingress.path . }}\"\n- name: SERVER_USEFORWARDHEADERS\n  value: \"true\"\n- name: SERVER_TOMCAT_INTERNALPROXIES\n  value: \".*\"\n"` |  |
| activiti-cloud-connector.image.pullPolicy | string | `"Always"` |  |
| activiti-cloud-connector.image.repository | string | `"activiti/example-cloud-connector"` |  |
| activiti-cloud-connector.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| activiti-cloud-connector.ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-header" | string | `"Authorization, Content-Type, Accept"` |  |
| activiti-cloud-connector.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| activiti-cloud-connector.ingress.path | string | `"/example-cloud-connector"` |  |
| activiti-cloud-connector.probePath | string | `"{{ tpl .Values.ingress.path . }}/actuator/info"` |  |
| activiti-cloud-connector.resources.limits.cpu | string | `"1"` |  |
| activiti-cloud-connector.resources.limits.memory | string | `"1024Mi"` |  |
| activiti-cloud-connector.resources.requests.cpu | string | `"150m"` |  |
| activiti-cloud-connector.resources.requests.memory | string | `"256Mi"` |  |
| activiti-cloud-connector.service.name | string | `"example-cloud-connector"` |  |
| activiti-cloud-identity.enabled | bool | `true` |  |
| activiti-cloud-identity.keycloak.extraEnv | string | `"- name: KEYCLOAK_IMPORT\n  value: /realm/realm.json\n"` |  |
| activiti-cloud-identity.keycloak.extraVolumeMounts | string | `"- name: realm-secret\n  mountPath: \"/realm/\"\n  readOnly: true\n"` |  |
| activiti-cloud-identity.keycloak.extraVolumes | string | `"- name: realm-secret\n  secret:\n    secretName: realm-secret\n"` |  |
| activiti-cloud-identity.keycloak.image.pullPolicy | string | `"IfNotPresent"` |  |
| activiti-cloud-identity.keycloak.image.repository | string | `"alfresco/alfresco-identity-service"` |  |
| activiti-cloud-identity.keycloak.image.tag | string | `"1.4.0-SNAPSHOT"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."nginx.ingress.kubernetes.io/affinity" | string | `"cookie"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"false"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."nginx.ingress.kubernetes.io/proxy-buffer-size" | string | `"16k"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."nginx.ingress.kubernetes.io/session-cookie-hash" | string | `"sha1"` |  |
| activiti-cloud-identity.keycloak.ingress.annotations."nginx.ingress.kubernetes.io/session-cookie-name" | string | `"identity_affinity_route"` |  |
| activiti-cloud-identity.keycloak.ingress.enabled | bool | `true` |  |
| activiti-cloud-identity.keycloak.ingress.hosts[0] | string | `"{{ template \"common.keycloak-host\" . }}"` |  |
| activiti-cloud-identity.keycloak.ingress.path | string | `"/auth"` |  |
| activiti-cloud-identity.keycloak.password | string | `"admin"` |  |
| activiti-cloud-identity.keycloak.persistence.dbPassword | string | `"keycloak"` |  |
| activiti-cloud-identity.keycloak.persistence.dbVendor | string | `"postgres"` |  |
| activiti-cloud-identity.keycloak.persistence.deployPostgres | bool | `true` |  |
| activiti-cloud-identity.keycloak.resources.limits.memory | string | `"1024Mi"` |  |
| activiti-cloud-identity.keycloak.resources.requests.memory | string | `"750Mi"` |  |
| activiti-cloud-identity.keycloak.username | string | `"admin"` |  |
| activiti-cloud-identity.postgresql.commonAnnotations.application | string | `"keycloak"` |  |
| activiti-cloud-identity.postgresql.nameOverride | string | `"postgresql-id"` |  |
| activiti-cloud-identity.postgresql.persistence.enabled | bool | `true` |  |
| activiti-cloud-identity.postgresql.postgresqlPassword | string | `"keycloak"` |  |
| activiti-cloud-identity.postgresql.resources.limits.cpu | string | `"1"` |  |
| activiti-cloud-identity.postgresql.resources.limits.memory | string | `"500Mi"` |  |
| activiti-cloud-identity.postgresql.resources.requests.cpu | string | `"300m"` |  |
| activiti-cloud-identity.postgresql.resources.requests.memory | string | `"250Mi"` |  |
| activiti-cloud-identity.realm.extraClientRoles | string | `nil` |  |
| activiti-cloud-identity.realm.extraClients | string | `nil` |  |
| activiti-cloud-identity.realm.extraGroups[0].name | string | `"hr"` |  |
| activiti-cloud-identity.realm.extraGroups[0].realmRoles[0] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraGroups[1].name | string | `"sales"` |  |
| activiti-cloud-identity.realm.extraGroups[1].realmRoles[0] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraGroups[2].name | string | `"testgroup"` |  |
| activiti-cloud-identity.realm.extraGroups[3].name | string | `"processadmin"` |  |
| activiti-cloud-identity.realm.extraGroups[3].realmRoles[0] | string | `"ACTIVITI_ADMIN"` |  |
| activiti-cloud-identity.realm.extraRealmRoles | string | `nil` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.broker[0] | string | `"read-token"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[0] | string | `"manage-users"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[1] | string | `"manage-clients"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[2] | string | `"manage-authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[3] | string | `"manage-events"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[4] | string | `"manage-realm"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[5] | string | `"create-client"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[6] | string | `"impersonation"` |  |
| activiti-cloud-identity.realm.extraUsers[0].clientRoles.realm-management[7] | string | `"realm-admin"` |  |
| activiti-cloud-identity.realm.extraUsers[0].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[0].credentials[0].value | string | `"client"` |  |
| activiti-cloud-identity.realm.extraUsers[0].email | string | `"client@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[0].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[0].firstName | string | `"client"` |  |
| activiti-cloud-identity.realm.extraUsers[0].lastName | string | `"client"` |  |
| activiti-cloud-identity.realm.extraUsers[0].realmRoles[0] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[0].realmRoles[1] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[0].realmRoles[2] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[0].username | string | `"client"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.broker[0] | string | `"read-token"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[0] | string | `"manage-users"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[1] | string | `"manage-clients"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[2] | string | `"manage-authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[3] | string | `"manage-events"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[4] | string | `"manage-realm"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[5] | string | `"create-client"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[6] | string | `"impersonation"` |  |
| activiti-cloud-identity.realm.extraUsers[1].clientRoles.realm-management[7] | string | `"realm-admin"` |  |
| activiti-cloud-identity.realm.extraUsers[1].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[1].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[1].email | string | `"admin@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[1].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[1].firstName | string | `"admin"` |  |
| activiti-cloud-identity.realm.extraUsers[1].lastName | string | `"admin"` |  |
| activiti-cloud-identity.realm.extraUsers[1].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[1].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[1].realmRoles[2] | string | `"user"` |  |
| activiti-cloud-identity.realm.extraUsers[1].username | string | `"admin"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.broker[0] | string | `"read-token"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[0] | string | `"manage-users"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[1] | string | `"manage-clients"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[2] | string | `"manage-authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[3] | string | `"manage-events"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[4] | string | `"manage-realm"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[5] | string | `"create-client"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[6] | string | `"impersonation"` |  |
| activiti-cloud-identity.realm.extraUsers[2].clientRoles.realm-management[7] | string | `"realm-admin"` |  |
| activiti-cloud-identity.realm.extraUsers[2].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[2].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[2].email | string | `"superadminuser@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[2].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[2].firstName | string | `"Super Admin"` |  |
| activiti-cloud-identity.realm.extraUsers[2].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[2].realmRoles[0] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[2].realmRoles[1] | string | `"ACTIVITI_ADMIN"` |  |
| activiti-cloud-identity.realm.extraUsers[2].realmRoles[2] | string | `"ACTIVITI_MODELER"` |  |
| activiti-cloud-identity.realm.extraUsers[2].realmRoles[3] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[2].realmRoles[4] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[2].username | string | `"superadminuser"` |  |
| activiti-cloud-identity.realm.extraUsers[3].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[3].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[3].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[3].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[3].email | string | `"hruser@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[3].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[3].firstName | string | `"HR"` |  |
| activiti-cloud-identity.realm.extraUsers[3].groups[0] | string | `"/hr"` |  |
| activiti-cloud-identity.realm.extraUsers[3].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[3].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[3].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[3].realmRoles[2] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[3].username | string | `"hruser"` |  |
| activiti-cloud-identity.realm.extraUsers[4].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[4].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[4].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[4].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[4].email | string | `"processadminuser@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[4].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[4].firstName | string | `"Process Admin"` |  |
| activiti-cloud-identity.realm.extraUsers[4].groups[0] | string | `"/processadmin"` |  |
| activiti-cloud-identity.realm.extraUsers[4].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[4].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[4].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[4].realmRoles[2] | string | `"ACTIVITI_ADMIN"` |  |
| activiti-cloud-identity.realm.extraUsers[4].username | string | `"processadminuser"` |  |
| activiti-cloud-identity.realm.extraUsers[5].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[5].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[5].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[5].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[5].email | string | `"salesuser@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[5].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[5].firstName | string | `"Sales"` |  |
| activiti-cloud-identity.realm.extraUsers[5].groups[0] | string | `"/sales"` |  |
| activiti-cloud-identity.realm.extraUsers[5].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[5].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[5].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[5].realmRoles[2] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[5].username | string | `"salesuser"` |  |
| activiti-cloud-identity.realm.extraUsers[6].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[6].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[6].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[6].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[6].email | string | `"testuser@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[6].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[6].firstName | string | `"Test"` |  |
| activiti-cloud-identity.realm.extraUsers[6].groups[0] | string | `"/testgroup"` |  |
| activiti-cloud-identity.realm.extraUsers[6].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[6].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[6].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[6].realmRoles[2] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[6].username | string | `"testuser"` |  |
| activiti-cloud-identity.realm.extraUsers[7].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[7].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[7].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[7].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[7].email | string | `"testadmin@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[7].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[7].firstName | string | `"Test"` |  |
| activiti-cloud-identity.realm.extraUsers[7].groups[0] | string | `"/testgroup"` |  |
| activiti-cloud-identity.realm.extraUsers[7].lastName | string | `"Admin"` |  |
| activiti-cloud-identity.realm.extraUsers[7].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[7].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[7].realmRoles[2] | string | `"ACTIVITI_USER"` |  |
| activiti-cloud-identity.realm.extraUsers[7].realmRoles[3] | string | `"ACTIVITI_ADMIN"` |  |
| activiti-cloud-identity.realm.extraUsers[7].username | string | `"testadmin"` |  |
| activiti-cloud-identity.realm.extraUsers[8].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[8].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[8].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[8].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[8].email | string | `"modeler@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[8].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[8].firstName | string | `"Modeler"` |  |
| activiti-cloud-identity.realm.extraUsers[8].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[8].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[8].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[8].realmRoles[2] | string | `"ACTIVITI_MODELER"` |  |
| activiti-cloud-identity.realm.extraUsers[8].username | string | `"modeler"` |  |
| activiti-cloud-identity.realm.extraUsers[9].clientRoles.account[0] | string | `"manage-account"` |  |
| activiti-cloud-identity.realm.extraUsers[9].clientRoles.account[1] | string | `"view-profile"` |  |
| activiti-cloud-identity.realm.extraUsers[9].credentials[0].type | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[9].credentials[0].value | string | `"password"` |  |
| activiti-cloud-identity.realm.extraUsers[9].email | string | `"modeler-qa@example.com"` |  |
| activiti-cloud-identity.realm.extraUsers[9].enabled | bool | `true` |  |
| activiti-cloud-identity.realm.extraUsers[9].firstName | string | `"Modeler"` |  |
| activiti-cloud-identity.realm.extraUsers[9].lastName | string | `"User"` |  |
| activiti-cloud-identity.realm.extraUsers[9].realmRoles[0] | string | `"offline_access"` |  |
| activiti-cloud-identity.realm.extraUsers[9].realmRoles[1] | string | `"uma_authorization"` |  |
| activiti-cloud-identity.realm.extraUsers[9].realmRoles[2] | string | `"ACTIVITI_MODELER"` |  |
| activiti-cloud-identity.realm.extraUsers[9].username | string | `"modeler-qa"` |  |
| activiti-cloud-modeling.enabled | bool | `true` |  |
| activiti-cloud-modeling.extraEnv | string | `"- name: SERVER_SERVLET_CONTEXTPATH\n  value: \"{{ tpl .Values.ingress.path . }}\"\n- name: SERVER_USEFORWARDHEADERS\n  value: \"true\"\n- name: SERVER_TOMCAT_INTERNALPROXIES\n  value: \".*\"\n"` |  |
| activiti-cloud-modeling.image.pullPolicy | string | `"Always"` |  |
| activiti-cloud-modeling.image.repository | string | `"activiti/activiti-cloud-modeling"` |  |
| activiti-cloud-modeling.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| activiti-cloud-modeling.ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-header" | string | `"Authorization, Content-Type, Accept"` |  |
| activiti-cloud-modeling.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| activiti-cloud-modeling.ingress.path | string | `"/modeling-service"` |  |
| activiti-cloud-modeling.postgres.enabled | bool | `true` |  |
| activiti-cloud-modeling.postgres.name | string | `"postgresql"` |  |
| activiti-cloud-modeling.probePath | string | `"{{ tpl .Values.ingress.path . }}/actuator/info"` |  |
| activiti-cloud-modeling.resources.limits.cpu | string | `"1"` |  |
| activiti-cloud-modeling.resources.limits.memory | string | `"1024Mi"` |  |
| activiti-cloud-modeling.resources.requests.cpu | string | `"400m"` |  |
| activiti-cloud-modeling.resources.requests.memory | string | `"512Mi"` |  |
| activiti-cloud-modeling.service.name | string | `"modeling"` |  |
| activiti-cloud-query.enabled | bool | `true` |  |
| activiti-cloud-query.image.pullPolicy | string | `"Always"` |  |
| activiti-cloud-query.image.repository | string | `"activiti/activiti-cloud-query"` |  |
| activiti-cloud-query.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| activiti-cloud-query.ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-header" | string | `"Authorization, Content-Type, Accept"` |  |
| activiti-cloud-query.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| activiti-cloud-query.postgres.enabled | bool | `true` |  |
| activiti-cloud-query.postgres.name | string | `"postgresql"` |  |
| activiti-cloud-query.resources.limits.cpu | string | `"1.5"` |  |
| activiti-cloud-query.resources.limits.memory | string | `"2048Mi"` |  |
| activiti-cloud-query.resources.requests.cpu | string | `"200m"` |  |
| activiti-cloud-query.resources.requests.memory | string | `"512Mi"` |  |
| activiti-cloud-query.service.name | string | `"query"` |  |
| activiti-modeling-app.enabled | bool | `true` |  |
| activiti-modeling-app.env.APP_CONFIG_BPM_HOST | string | `"{{ include \"common.gateway-url\" . }}"` |  |
| activiti-modeling-app.image.pullPolicy | string | `"Always"` |  |
| activiti-modeling-app.image.repository | string | `"activiti/activiti-modeling-app"` |  |
| activiti-modeling-app.ingress.path | string | `"/modeling"` |  |
| activiti-modeling-app.nameOverride | string | `"activiti-modeling-app"` |  |
| global | object | `{"extraEnv":"\n# - name: PROPERTY_NAME\n#   value: \"propertyValue\"\n","gateway":{"annotations":null,"domain":"DOMAIN","host":"gateway-{{ .Release.Namespace }}.{{ template \"common.gateway-domain\" . }}","http":"true","tlsacme":"false"},"keycloak":{"extraEnv":"\n# - name: PROPERTY_NAME\n#   value: \"propertyValue\"\n","host":"identity-{{ .Release.Namespace }}.{{ template \"common.gateway-domain\" . }}","realm":"activiti","resource":"activiti","url":""},"registryPullSecrets":[]}` | for common values see https://github.com/Activiti/activiti-cloud-common-chart/blob/master/charts/common/README.md |
| global.extraEnv | string | `"\n# - name: PROPERTY_NAME\n#   value: \"propertyValue\"\n"` | Use Yaml formatted string to add extra environment properties to all deployments, i.e. |
| global.gateway.annotations | string | `nil` | Configure global annotations for all service ingresses |
| global.gateway.domain | string | `"DOMAIN"` | Set to configure gateway domain template, i.e. {{ .Release.Namespace }}.1.3.4.5.nip.io $ helm upgrade aae . --install --set global.gateway.domain=1.2.3.4.nip.io |
| global.gateway.host | string | `"gateway-{{ .Release.Namespace }}.{{ template \"common.gateway-domain\" . }}"` | Set to configure single host domain name for all services |
| global.gateway.http | string | `"true"` | Set to false enables HTTPS configuration on all urls |
| global.gateway.tlsacme | string | `"false"` | Set to enable automatic TLS for ingress if https is enabled |
| global.keycloak.extraEnv | string | `"\n# - name: PROPERTY_NAME\n#   value: \"propertyValue\"\n"` | Use Yaml formatted string to add extra environment properties to keycloak deployment, i.e. |
| global.keycloak.host | string | `"identity-{{ .Release.Namespace }}.{{ template \"common.gateway-domain\" . }}"` | Configure Keycloak host template |
| global.keycloak.realm | string | `"activiti"` | Configure Keycloak realm |
| global.keycloak.resource | string | `"activiti"` | Configure Keycloak resource |
| global.keycloak.url | string | `""` | Set full url to configure external Keycloak, otherwise will be generated based on host |
| global.registryPullSecrets | list | `[]` | Configure pull secrets for all deployments |
| postgresql.commonAnnotations.application | string | `"activiti"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.postgresqlPassword | string | `"password"` |  |
| postgresql.resources.requests.cpu | string | `"350m"` |  |
| postgresql.resources.requests.memory | string | `"512Mi"` |  |
| rabbitmq.auth.erlangCookie | string | `"ylY79lOdNUWsJEwAGdVQnhjSazV4QZKO="` |  |
| rabbitmq.auth.password | string | `"guest"` |  |
| rabbitmq.auth.username | string | `"guest"` |  |
| rabbitmq.enabled | bool | `true` |  |
| rabbitmq.extraPlugins | string | `""` |  |
| rabbitmq.livenessProbe.timeoutSeconds | int | `90` |  |
| rabbitmq.readinessProbe.timeoutSeconds | int | `90` |  |
| rabbitmq.resources.limits.memory | string | `"1500Mi"` |  |
| rabbitmq.resources.requests.memory | string | `"1500Mi"` |  |
| runtime-bundle.enabled | bool | `true` |  |
| runtime-bundle.extraEnv | string | `"- name: SERVER_SERVLET_CONTEXTPATH\n  value: \"{{ tpl .Values.ingress.path . }}\"\n- name: SERVER_USEFORWARDHEADERS\n  value: \"true\"\n- name: SERVER_TOMCAT_INTERNALPROXIES\n  value: \".*\"\n"` |  |
| runtime-bundle.image.pullPolicy | string | `"Always"` |  |
| runtime-bundle.image.repository | string | `"activiti/example-runtime-bundle"` |  |
| runtime-bundle.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| runtime-bundle.ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-header" | string | `"Authorization, Content-Type, Accept"` |  |
| runtime-bundle.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| runtime-bundle.ingress.path | string | `"/rb"` |  |
| runtime-bundle.postgres.enabled | bool | `true` |  |
| runtime-bundle.postgres.name | string | `"postgresql"` |  |
| runtime-bundle.probePath | string | `"{{ tpl .Values.ingress.path . }}/actuator/info"` |  |
| runtime-bundle.resources.limits.cpu | string | `"2"` |  |
| runtime-bundle.resources.limits.memory | string | `"2048Mi"` |  |
| runtime-bundle.resources.requests.cpu | string | `"200m"` |  |
| runtime-bundle.resources.requests.memory | string | `"512Mi"` |  |
| runtime-bundle.service.name | string | `"rb"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.4.0](https://github.com/norwoodj/helm-docs/releases/v1.4.0)
