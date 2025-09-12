package com.realmatez.task_manager
import com.google.android.play.core.install.model.InstallStatus
interface AppUpdateInstallerListener {
    open fun onStatus(@InstallStatus status: Int) {}
    abstract fun onDownloadedButNotInstalled()
    abstract fun onFailure(e: Exception)
    abstract fun onNotUpdate()
    abstract fun onCancelled()
}