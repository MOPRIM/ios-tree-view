Pod::Spec.new do |s|
  s.name = 'UITreeView'
  s.version = '1.0'
  s.summary = 'A custom UIView to show hierarchical data'
  s.homepage = 'https://github.com/MOPRIM/ios-tree-view'
  s.license = 'Apache 2.0'
  s.author = 'Moprim'
  s.source = { git: 'https://github.com/MOPRIM/ios-tree-view.git', tag: s.version.to_s }

  s.source_files = 'UITreeView/**/*.swift'

  s.ios.deployment_target = '8.2'
  s.tvos.deployment_target = '9.0'

  s.swift_version = '5.0'
  s.swift_versions = ['4.0', '4.2', '5.0']

  s.frameworks = 'UIKit'
end