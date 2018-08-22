




resource "aws_instance" "elk" {
  ami           = "ami-b9889653"
  instance_type = "t2.micro"
  key_name      = "${var.key}"
  subnet_id = "${aws_subnet.elk_subnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.elk_security_group.id}",
  ]

  provisioner "file" {
    content      = "network.bind_host: 0.0.0.0"
    destination   = "/tmp/elasticsearch.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    content       = "server.host: 0.0.0.0"
    destination   = "/tmp/kibana.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    content       = "http.host: 0.0.0.0"
    destination   = "/tmp/logstash.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    source        = "${path.module}/filebeat.yml"
    destination   = "/tmp/filebeat.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    source        = "${path.module}/beats.conf"
    destination   = "/tmp/beats.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "remote-exec" {
    script        = "${path.module}/elasticsearch.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  depends_on = ["aws_security_group.elk_security_group"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elk.id}"
}
