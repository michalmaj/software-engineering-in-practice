# Java capstone starter

Copy this entire directory's contents into the root of your team's new
repository (this file included — it won't overwrite your own `README.md`,
since it has a different name; read it once, then it's safe to delete),
then:

```bash
./gradlew test
./gradlew build
```

This ships a real, committed Gradle Wrapper (`gradlew`, `gradlew.bat`,
`gradle/wrapper/`), pinned to Gradle 8.10.2, plus a JUnit 5 test. You only
need JDK 21 on your machine — the wrapper downloads the pinned Gradle
version itself the first time you run it. Nothing here knows anything
about TableTime — it's just enough tooling (a build file, one passing
test) to build on, matching the Java side of Lab 14.
