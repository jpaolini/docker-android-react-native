# docker-android-react-native
[![](https://images.microbadger.com/badges/image/jpaolini/docker-android-react-native.svg)](https://microbadger.com/images/jpaolini/docker-android-react-native "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jpaolini/docker-android-react-native.svg)](https://microbadger.com/images/jpaolini/docker-android-react-native "Get your own version badge on microbadger.com")

The purpose of this image is to provide a docker image for building android react-native applications.

## Defaults
The image is configured with the following defaults

* node = v8.9.0
* yarn = 1.3.2
* react-native-cli = latest when building image (yarn global add react-native-cli)

## Getting Started

When building the image, both node and yarn are configured as arguments and can be set like:

```
docker build -t org/image:tag --build-arg NODE_VERSION=8.9.0 --build-arg YARN_VERSION=1.3.2 .
```

## Using the image
The image can be used an executable to build your react-native android app.
By default it'll run **`./gradlew assembleDebug`**.  Here are some examples:

```
# first build the image
docker build -t org/image:tag .

# default build
docker run --rm -v REACT_NATIVE_ROOT:/app org/image:tag

# release build
docker run --rm -v REACT_NAITVE_ROOT:/app org/image:tag
```

## Signing Builds
The default for this image is that the signing information is included in the project.
To setpup signing keys you can follow the [react-native-guide](https://facebook.github.io/react-native/docs/signed-apk-android.html)

**Assumptions**
* you followed the steps [here](https://facebook.github.io/react-native/docs/signed-apk-android.html) where in step 2 you added the key info to `~/.gradle/gradle.properties`

* the keystore file is located in your project under `android/app`

**Volume mount your gradle.properties**

```
docker run --rm -v REACT_NATIVE_ROOT:/app -v LOCAL_GRADLE_PROPERTIES:/root/.gradle/gradle.properties \
org/image:tag assembleRelease
```

**From the command line**
```
docker run --rm -v REACT_NAITVE_ROOT:/app \
org/image:tag assembleRelease \
-PMYAPP_RELEASE_STORE_PASSWORD="my-password" \
-PMYAPP_RELEASE_KEY_ALIAS="my-alias" \
-PMYAPP_RELEASE_KEY_PASSWORD="my-key-password" \
```
