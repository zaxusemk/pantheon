platforms := "linux/amd64,linux/arm64"

build-bl4st:
    docker buildx build --load --platform {{platforms}} -t zaxusemk/pantheon-bl4st -f pantheon-bl4st.dockerfile .