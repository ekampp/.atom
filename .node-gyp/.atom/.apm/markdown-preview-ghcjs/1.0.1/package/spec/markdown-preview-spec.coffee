path = require 'path'
{WorkspaceView} = require 'atom'
fs = require 'fs-plus'
temp = require 'temp'
wrench = require 'wrench'

describe "Markdown preview package", ->
  beforeEach ->
    fixturesPath = path.join(__dirname, 'fixtures')
    tempPath = temp.mkdirSync('atom')
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPath(tempPath)

    atom.workspaceView = new WorkspaceView
    atom.workspace = atom.workspaceView.model
    spyOn(MarkdownPreviewView.prototype, 'renderMarkdown')

    waitsForPromise ->
      atom.packages.activatePackage("markdown-preview-ghcjs")

    waitsForPromise ->
      atom.packages.activatePackage('language-gfm')
