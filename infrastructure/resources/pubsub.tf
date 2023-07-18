resource "google_pubsub_topic" "function-topic" {
  name = "demo-pubsub-topic"
}

resource "google_pubsub_topic" "deadletter-topic" {
  name = "demo-deadletter-topic"
}

resource "google_pubsub_subscription" "deadletter-subscription" {
  name = "demo-deadletter-subscription"
  topic = google_pubsub_topic.deadletter-topic.name

  depends_on = [
    google_pubsub_topic.deadletter-topic
  ]
}
