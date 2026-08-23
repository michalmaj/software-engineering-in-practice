# Java capstone starter

Copy this entire directory's contents into the root of your team's new
repository, then:

```bash
javac *.java -d out
java -cp out App
java -cp out AppCheck
```

This uses plain `javac`/`java` with a hand-written check class — the
same pattern as Lab 14's `NotifierCheck.java` — deliberately, not
Gradle or JUnit, to avoid a build-tool learning curve on top of
everything else the capstone already asks of your team. If your team
wants a real build tool and test framework, introducing the Gradle
Wrapper is a reasonable ADR-worthy decision to make yourselves — see
Lab 26.
