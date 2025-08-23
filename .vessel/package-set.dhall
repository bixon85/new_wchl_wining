let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.8.4-20230505/package-set.dhall sha256:c4bd3b9ffaf6b48d21841545306d9f69b57e79ce3b1ac5e1f63b068ca4f89957
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [] : List Package

let overrides = [] : List Package

in  upstream # additions # overrides