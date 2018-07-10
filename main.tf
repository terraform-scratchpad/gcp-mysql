provider "google" {
  region = "${var.region}"
  version = "1.15.0"
}

provider "random" {}

resource "random_string" "mysql-admin-username" {
  length = 10
  special = false
}

resource "random_string" "mysql-db-name" {
  length = 8
  special = false
  upper = false
}

resource "random_string" "mysql-admin-password" {
  length = 16
  special = true
  override_special = "/@><*&\" "
}

resource "google_sql_database_instance" "mysql-instance" {

  name = "mysql-master-instance"
  database_version = "MYSQL_5_7"
  region = "${var.region}"
  "settings" {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "mysql-db" {
  instance = "${google_sql_database_instance.mysql-instance.id}"
  name = "${random_string.mysql-db-name.id}"
}

resource "google_sql_user" "mysql-user" {
  instance = "${random_string.mysql-admin-username.id}"
  name = "worldcup"
  password = "${random_string.mysql-admin-password.id}"
}

output "db-instance-ip" {
  value = "${google_sql_database_instance.mysql-instance.ip_address}"
}

output "db-name" {
  value = "${google_sql_database.mysql-db.name}"
}

output "db-user" {
  value = "${google_sql_user.mysql-user.name}"
}

output "db-password" {
  value = "${google_sql_user.mysql-user.password}"
}