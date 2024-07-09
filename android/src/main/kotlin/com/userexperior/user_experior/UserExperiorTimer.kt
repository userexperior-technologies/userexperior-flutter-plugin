package com.userexperior.user_experior

class UserExperiorTimer {
    private var start: Long = 0L

    fun start() {
        start = System.nanoTime()
    }

    fun elapsedMicros(): Long {
        val current = System.nanoTime()
        return (current - start) / 1000
    }
}