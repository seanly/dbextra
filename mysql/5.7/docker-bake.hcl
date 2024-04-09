variable "VERSION" {
  default = "5.7.35"
}

variable "FIXID" {
  default = "1"
}


group "default" {
  targets = ["mysql"]
}

group "acr" {
  targets = ["mysql-amd64"]
}

target "mysql" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "mysql"
        "cloud.opsbox.image.version" = "${VERSION}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "Dockerfile"
    context  = "./"
    args = {
        VERSION="${VERSION}"
    }
    platforms = ["linux/amd64"]
    tags = ["seanly/dbset:mysql-${VERSION}-${FIXID}"]
    output = ["type=image,push=true"]
}

target "mysql-amd64" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "mysql"
        "cloud.opsbox.image.version" = "${VERSION}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "Dockerfile"
    context  = "./"
    args = {
        VERSION="${VERSION}"
    }
    platforms = ["linux/amd64"]
    tags = [
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}"
    ]
    output = ["type=image,push=true"]
}