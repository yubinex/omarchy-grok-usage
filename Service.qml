import QtQuick
import Quickshell
import Quickshell.Io

// This service owns no bar widget. It supplies grok.json for the stock
// omarchy.agents panel, preserving the normal Claude and Codex UI.
Item {
  id: root

  readonly property string moduleName: "yubinex.grok-usage"
  readonly property string pluginDir: Qt.resolvedUrl(".").toString().replace(/^file:\/\//, "")
  readonly property string collector: pluginDir + "/bin/grok-usage"

  function refresh() {
    if (!collect.running)
      collect.running = true
  }

  Timer {
    interval: 5 * 60 * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: collect
    command: ["/usr/bin/python3", root.collector, "--write"]
    stderr: SplitParser {
      onRead: data => console.warn(root.moduleName + ": " + data)
    }
    onExited: omarchyAgentsRefresh.running = true
  }

  Process {
    id: omarchyAgentsRefresh
    command: ["omarchy-shell", "-q", "omarchy.agents", "refresh"]
  }
}
