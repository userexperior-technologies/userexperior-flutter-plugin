package com.userexperior.user_experior

import com.userexperior.bridge.location.UEPlatformMask

fun HashMap<String, String>.toUEPlatformMask(): UEPlatformMask {
    val identifier = this["i"] ?: throw IllegalArgumentException("Identifier is required")
    val x = this["x"]?.toFloatOrNull() ?: throw IllegalArgumentException("x is required and must be a float")
    val y = this["y"]?.toFloatOrNull() ?: throw IllegalArgumentException("y is required and must be a float")
    val w = this["w"]?.toFloatOrNull() ?: throw IllegalArgumentException("width is required and must be a float")
    val h = this["h"]?.toFloatOrNull() ?: throw IllegalArgumentException("height is required and must be a float")
    return UEPlatformMask(identifier, x, y, w, h)
}