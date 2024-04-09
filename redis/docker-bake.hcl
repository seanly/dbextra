variable "VERSION" {
  default = "6.2.14"
}

variable "FIXID" {
  default = "1"
}


group "default" {
  targets = ["redis"]
}

group "acr" {
  targets = ["redis-amd64", "redis-arm64"]
}

target "redis" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "redis"
        "cloud.opsbox.image.version" = "${VERSION}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "Dockerfile"
    context  = "./"
    args = {
        VERSION="${VERSION}"
    }
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["seanly/dbset:redis-${VERSION}-${FIXID}"]
    output = ["type=image,push=true"]
}

target "redis-arm64" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "redis"
        "cloud.opsbox.image.version" = "${VERSION}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "Dockerfile"
    context  = "./"
    args = {
        VERSION="${VERSION}"
    }
    platforms = ["linux/arm64"]
    tags = [
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:redis-${VERSION}-${FIXID}-arm64",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:redis-${VERSION}-${FIXID}-arm64"
    ]
    output = ["type=image,push=true"]
}

target "redis-amd64" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "redis"
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
        "registry.cn-chengdu.aliyuncs.com/seanly/dbset:redis-${VERSION}-${FIXID}",
        "registry.cn-hangzhou.aliyuncs.com/seanly/dbset:redis-${VERSION}-${FIXID}"
    ]
    output = ["type=image,push=true"]
}