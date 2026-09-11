package com.example;

/**
 * Direct launcher class that bypasses JavaFX module requirement checks
 * when running via classpath or direct main invocations.
 */
public class Launcher {
    public static void main(String[] args) {
        App.main(args);
    }
}
