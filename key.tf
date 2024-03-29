variable "key_name" {
  type        = "string"
  description = "keypair name"
}
# キーファイル
## 生成場所のPATH指定をしたければ、ここを変更するとよい。
locals {
  public_key_file  = "/Users/moribehiroshishi/Desktop/keys/${var.key_name}.id_rsa.pub"
  private_key_file = "/Users/moribehiroshishi/Desktop/keys/${var.key_name}.id_rsa"
}

# キーペアを作る
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#秘密鍵を作る

resource "local_file" "private_key_pem" {
  filename = "${local.private_key_file}"
  content  = "${tls_private_key.keygen.private_key_pem}"

  # local_fileでファイルを作ると実行権限が付与されてしまうので、local-execでchmodしておく
  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
}

resource "local_file" "public_key_openssh" {
  filename = "${local.private_key_file}"
  content  = "${tls_private_key.keygen.public_key_openssh}"



  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
}

/**
 * output
 **/
# キー名
output "key_name" {
  value = "${var.key_name}"
}
# 秘密鍵ファイルPATH（このファイルを利用してサーバへアクセスする。）

output "private_key_file" {
  value = "${local.private_key_file}"
}

# 公開鍵ファイルPATH
output "public_key_file" {
  value = "${local.public_key_file}"
}

output "public_key_openssh" {
  value = "${tls_private_key.keygen.public_key_openssh}"
}


