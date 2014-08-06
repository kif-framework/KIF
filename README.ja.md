KIFのインストール
=====================================

KIFをインストールする方法が2つあります：CocoaPodsからインストール方法とgit submoduleを使ってGitHubからインストール方法．

1. CocoaPodsからインストール (一番簡単)
--------------------------

### テストターゲットを追加

![KIF15.30.00](https://gitlab.com/uploads/thii/sq/a97a6e2677/KIF15.30.00.png)

![KIF13.35.39](https://gitlab.com/uploads/thii/sq/44ff089976/KIF13.35.39.png)

![KIF13.36.36](https://gitlab.com/uploads/thii/sq/a0ebceaa17/KIF13.36.36.png)


### PodfileにKIFを追加

Podfileに下記のように追加する．

```
target 'Acceptance Tests', :exclusive => true do
    pod 'KIF'
end
```

Podfileがあるディレクトリに移動して下記のコマンドを実行する．

```
pod install
```

完了!


2. GitHubからインストール (ちょっと面倒)
--------------------------

### git submoduleにKIFを追加

```
cd /iOSプロジェクトのルートディレクトリ
mkdir Frameworks
git submodule add https://github.com/kif-framework/KIF.git Frameworks/KIF
```

### ワークスペースにKIFを追加
Frameworks/KIFディレクトリに入って，KIF.xcodeprojをXcodeにドラッグアンドドロップする．

![KIF13.32.58](https://gitlab.com/uploads/thii/sq/594efd7a48/KIF13.32.58.png)


### テストターゲットを追加

![KIF13.35.00](https://gitlab.com/uploads/thii/sq/f56efe625e/KIF13.35.00.png)

![KIF13.35.14](https://gitlab.com/uploads/thii/sq/8351b8bda0/KIF13.35.14.png)

![KIF13.35.39](https://gitlab.com/uploads/thii/sq/44ff089976/KIF13.35.39.png)

![KIF13.36.36](https://gitlab.com/uploads/thii/sq/a0ebceaa17/KIF13.36.36.png)


### テストターゲットを設定

![KIF13.49.25](https://gitlab.com/uploads/thii/sq/16a4e47dee/KIF13.49.25.png)

libKIF.aを追加

![KIF13.50.03](https://gitlab.com/uploads/thii/sq/11044b9136/KIF13.50.03.png)

以上の同様にCoreGraphics.frameworkを追加

![KIF15.13.35](https://gitlab.com/uploads/thii/sq/a06c41869b/KIF15.13.35.png)

完了!
