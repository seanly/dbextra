variable "VERSION" {
  default = "8.0.33"
}

variable "FIXID" {
  default = "1"
}


group "default" {
  targets = ["mysql", "mysql-debian"]
}

group "acr" {
  targets = ["mysql-amd64", "mysql-arm64", "mysql-debian-amd64"]
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
    target = "oracle"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["seanly/dbset:mysql-${VERSION}-${FIXID}"]
    output = ["type=image,push=true"]
}

target "mysql-debian" {
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
    target = "debian"
    platforms = ["linux/amd64"]
    tags = ["seanly/dbset:mysql-${VERSION}-debian-${FIXID}"]
    output = ["type=image,push=true"]
}

target "mysql-arm64" {
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
    target = "oracle"
    platforms = ["linux/arm64"]
    tags = [
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}-arm64",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}-arm64"
    ]
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
    target = "oracle"
    platforms = ["linux/amd64"]
    tags = [
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:mysql-${VERSION}-${FIXID}"
    ]
    output = ["type=image,push=true"]
}

target "mysql-debian-amd64" {
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
    target = "debian"
    platforms = ["linux/amd64"]
    tags = [
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:mysql-${VERSION}-debian-${FIXID}",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:mysql-${VERSION}-debian-${FIXID}"
    ]
    output = ["type=image,push=true"]
}