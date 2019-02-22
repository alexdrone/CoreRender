# CoreRender [![Swift](https://img.shields.io/badge/swift-4.*-orange.svg?style=flat)](#) [![ObjC++](https://img.shields.io/badge/ObjC++-blue.svg?style=flat)](#) [![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](#) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

<img src="docs/assets/logo_new.png" width=150 alt="Render" align=right />

CoreRender is an ObjC++ *(Swift compatible)* minimal and performance-oriented implementation of [Render](https://github.com/alexdrone/Render).

### Introduction

* **Declarative:** CoreRender uses a declarative API to define UI components. You simply describe the layout for your UI based on a set of inputs and the framework takes care of the rest (*diff* and *reconciliation* from virtual view hierarchy to the actual one under the hood).
* **Flexbox layout:** CoreRender includes the robust and battle-tested Facebook's [Yoga](https://facebook.github.io/yoga/) as default layout engine.
* **Fine-grained recycling:** Any component such as a text or image can be recycled and reused anywhere in the UI.

### Installing the framework

```bash
cd {PROJECT_ROOT_DIRECTORY}
curl "https://raw.githubusercontent.com/alexdrone/CoreRender/master/bin/dist.zip" > dist.zip && unzip dist.zip && rm dist.zip;
```

Drag `CoreRender.framework` in your project and add it as an embedded binary.

If you use [xcodegen](https://github.com/yonaskolb/XcodeGen) add the framework to your *project.yml* like so:

```yaml
targets:
  YOUR_APP_TARGET:
    ...
    dependencies:
      - framework: PATH/TO/YOUR/DEPS/CoreRender.framework
```
