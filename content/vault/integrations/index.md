---
title: "Integrations"
description: ""
lead: ""
date: 2020-10-06T08:49:31+00:00
lastmod: 2020-10-06T08:49:31+00:00
draft: false
images: []
menu:
    vault:
        parent: "vault"
weight: 306
toc: true
---

One of the key differentiators, is the ability to extend and integrate. Next to uploading and persisting recordings on your preferred storage providers, Kerberos Vault can trigger events and be configured through APIs.

Each time a Kerberos Agent sends a recording to Kerberos Vault, it is persisted on a storage provider, and an event is triggered through one of the following integrations.

- [Apache Kafka](https://kafka.apache.org/)
- [Amazon Web Services SQS](https://aws.amazon.com/sqs/)
- [Kerberos Hub](/hub/first-things-first/)
- Kerberos Vault (remote forwarding)

Every time an event is delivered, it will be consumed by the configured integrations. For example in case of a Kafka
integration, one can build a Kafka consumer with custom application logic; a notification manager, a machine learning
service, etc.

## Prerequisites

Before you can configure a provider, make sure [you have installed a Kerberos Vault](/vault/installation) inside a Kubernetes cluster.

## Configuration of an integration

Once you have set up your Kerberos Vault instance, and have successfully login to the application, you should see the integration navigation item on the left.

{{< figure src="integrations.gif" alt="One or more providers can be configured to centralise your storage." caption="One or more providers can be configured to centralise your storage." class="stretch">}}

When selecting the `+ Add Integration` button, a modal will open that allows you to configure a specific integration. Go a head and select one from the list.

{{< figure src="add-integration.gif" alt="Configure, add and validate a new integration." caption="Configure, add and validate a new integration." class="stretch">}}

Once completed the necessary credentials, specific to your integration, you can verify the connection by click the `Validate` button. If ok, it should return a `green` confirmation box, if something went wrong you should see the relevant error message in a `red` alert box. When completed you can add multiple and different integrations.

## Cloud event integrations

Kerberos Vault integrates with queues and message brokers in the cloud such as AWS SQS. The advantage is that it takes the complete control of your every growing messaging/event requirements. 

### AWS SQS

> Tutorial to be written.

## Edge event integrations

Alternatives to cloud event integrations are self-hosted variants such as a Kafka broker.

### Kafka

Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

To integrate a Kafka broker with Kerberos vault you could install your existing Kafka installation, or on board a new Kafka broker inside your Kubernetes cluster. Before installing the Kafka broker, we will need to set up a storage class. As previously mentioned we will use OpenEBS for that, but you could use the storage class you prefer.

    kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml

Once OpenEBS is installed and configured, go ahead with setting up the Kafka broker.

    kubectl create namespace kafka
    helm install kafka bitnami/kafka -f https://raw.githubusercontent.com/kerberos-io/vault/master/yaml/kafka/kafka.values.yaml -n kafka

Once done you should see the relevant kafka pods and zookeeper being deployed

    kubectl get po -n kafka

Now you are ready to configure the Kerberos Vault integration, by selecting the Kafka option. You should add the Kafka credentials and authentication mechanism.

{{< figure src="kafka.gif" alt="Configure, add and validate the Kafka integration." caption="Configure, add and validate the Kafka integration." class="stretch">}}

- Integration name: this a preferred name for the integration.
- Broker: the url of the broker `kafka.kafka:9092`.
- Group: the group to which messages are produced, this can be any value you want.
- Topic: the topic to which a message is produced, if the topic doesn't exist, it will be created automatically.
- Username: the username, `Yourusername`.
- Password: the password, `Yourpassword`.
- Mechanism: the kafka mechanism, `PLAIN`.
- Security: the kafka security, `SASL_PLAINTEXT`.

## Kerberos integrations

Next to third party integrations such as Kafka or AWS SQS, it is possible to integrate with a remote Kerberos Vault, also called chaining or forwarding or with Kerberos Hub.

### Kerberos Vault

Kerberos Vaults can be chained and configured in forwarding mode. This configuration makes it possible to enable offline capabilities and keep the majority of your recordings at the edge. Only a subset of your recordings will be transferred from the edge to the cloud by requesting a forward from Kerberos Hub or building your own forwarding application code.

{{< figure src="vault-forwarding.gif" alt="Two forwarding modes continuous and on demand." caption="Two forwarding modes continuous and on demand." class="stretch">}}

To learn more about how to enable the Kerberos Vault integration, have [a look at the forwarding page]().

### Kerberos Hub

The Kerberos Hub integration allows you to send messages from Kerberos Vault and Kerberos Hub, through [the Kerberos Hub pipeline](/hub/pipeline). Messages are sent to the REST API of Kerberos Hub, and injected in the Kerberos Hub pipeline. Once message is injected in the internal message broker (Kafka), it will create all the relevant information and metadata in Kerberos Hub.

{{< figure src="vault-integration-hub.gif" alt="Kerberos Hub integrates with Kerberos Vault to visualise recordings and metadata." caption="Kerberos Hub integrates with Kerberos Vault to visualise recordings and metadata." class="stretch">}}

- Integration name: this a preferred name for the integration.
- Kerberos Hub Url: the url to the API of Kerberos Hub, `https://api.your.hub.com`
- Hub Key: this is the cloud key that is assigned to your user (owner accounts), by default this is `AKIAxxxxxxG5Q`.
