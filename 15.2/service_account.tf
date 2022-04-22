// Create SA
resource "yandex_iam_service_account" "sa-netology" {
  folder_id = var.folder_id
  name      = "netology"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-netology.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-netology-static-key" {
  service_account_id = yandex_iam_service_account.sa-netology.id
  description        = "static access key for object storage"
}