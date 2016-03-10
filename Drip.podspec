Pod::Spec.new do |s|
  s.name    = 'Drip'
  s.version = '0.0.1'
  s.summary = 'Lightweight dependency injection for Swift'

  s.ios.deployment_target = '8.0'

  s.description = <<-DESC
    A lightweight Swift DI library, inspired by Dagger. Provides a mechanism for scoping
    dependencies and eliminating the shared instance pattern. Relies on type inference to
    determine injected dependencies, rather than require it be passed explicitly.
  DESC

  s.homepage = 'https://github.com/devmynd/Drip'
  s.license  = { type: 'MIT', file: 'LICENSE' }
  s.author = { 'Ty Cobb' => 'ty.cobb.m@gmail.com' }
  s.social_media_url = 'http://twitter.com/wzrad'

  s.source = { git: 'https://github.com/devmynd/drip.git', tag: 'v0.0.1' }
  s.source_files  = 'Drip/**/*'
  s.requires_arc = true
end
