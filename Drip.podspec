Pod::Spec.new do |s|
  s.name    = 'Drip'
  s.version = '0.1.0'
  s.summary = 'Lightweight dependency injection for Swift'

  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'

  s.description = <<-DESC
    A lightweight, dagger-ish Swift DI library. Provides mechanisms for scoping dependencies
    and eliminating the singleton pattern. Relies on type inference to resolve injected dependencies,
    rather than require types be passed explicitly.
  DESC

  s.homepage = 'https://github.com/devmynd/Drip'
  s.license  = { type: 'MIT', file: 'LICENSE' }
  s.author = { 'Ty Cobb' => 'ty.cobb.m@gmail.com' }
  s.social_media_url = 'http://twitter.com/wzrad'

  s.source = { git: 'https://github.com/devmynd/drip.git', tag: 'v0.1.0' }
  s.source_files  = 'Drip/**/*.swift'
  s.requires_arc = true
end
