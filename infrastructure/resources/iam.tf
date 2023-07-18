data "external" "trigger-info" {
  program = ["bash", "${path.module}/../scripts/get_trigger_info.sh"]

  query = {
    function_name = google_cloudfunctions2_function.cloud-function.name
    region = var.gcp-region
    dl_topic = google_pubsub_topic.deadletter-topic.name
  }
  depends_on = [
    google_cloudfunctions2_function.cloud-function,
    google_pubsub_topic.deadletter-topic
  ]
}

resource "google_pubsub_topic_iam_member" "deadletter-publisher" {
  project = var.gcp-project
  topic = google_pubsub_topic.deadletter-topic.name
  role = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${var.gcp-project-number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  depends_on = [
    google_pubsub_topic.deadletter-topic
  ]
}

resource "google_pubsub_subscription_iam_member" "deadletter-subscriber-role" {
  project = var.gcp-project
  subscription = data.external.trigger-info.result.trigger_subscription
  role = "roles/pubsub.subscriber"
  member  = "serviceAccount:service-${var.gcp-project-number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  depends_on = [
    data.external.trigger-info,
    google_cloudfunctions2_function.cloud-function
  ]
}