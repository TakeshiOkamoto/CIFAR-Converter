# CIFAR Converter
  
Reading and writing CIFAR file format. and, you can try TensorFlow's CIFAR-10 tutorials with the original dataset.  
(CIFARファイルの読み書き。そして、TensorFlowのCIFAR-10サンプルをオリジナルデータセットで試せます。)  
  
<img src="https://github.com/TakeshiOkamoto/CIFAR-Converter/blob/master/image.png">  
  
You only preparing images.    
(あなたは画像を用意するだけです。)
  
# How to use (使い方)    
  
## 1. Creation of training and evaluation file (訓練/評価ファイルの作成)  
  
Create with "IMAGE to CIFAR" of cifar.exe.  
(cifar.exeの「IMAGE to CIFAR」で作成します。)  
  
CIFAR file format is no distinction between training and evaluation file.  
(CIFARのファイルフォーマットでは訓練、評価ファイルの区別はありません。)  
  
## 2. File placement (ファイルの配置)    
  
Place the following files in the same folder.  
(次のファイルを同じフォルダに配置します。)  

| File | 
|----| 
|cifar10.py|
|cifar10_eval.py|
|cifar10_ini.py|
|cifar10_input.py|
|cifar10_train.py|
|try.ipynb|
|Training file (Created in Chapter 1 / 1章で作成)|
|Evaluation file (Created in Chapter 1 / 1章で作成)|  
  
## 3. Edit settings (設定の編集)    
  
Fit the cifar10_ini.py file to your environment.  
(cifar10_ini.pyファイルを各自の環境にあわせます。)  

## 4. Run training (訓練の実行)    
  
```rb
python cifar10_train.py --max_steps=100000
```  
  
## 5. Run evaluation (評価の実行)    
  
```rb
python cifar10_eval.py
```  
  
## 6. Try model (モデルを試す)  
  
Just run "try.ipynb" with Jupyter Notebook.  
(後は、Jupyter Notebookで「try.ipynb」を実行するだけです。)  
  
but, please change the file name of test.jpg.  
(但し、test.jpgのファイル名は変更してください。)  
  
# Mac / Linux  

cifar.exe can be executed on Windows.  
(cifar.exeはWindowsで実行可能です。)  
  
Mac / Linux users have source code, please compile with "Lazarus".  
(Mac / Linuxの方はソースコードがありますので、"Lazarus"でコンパイルして下さい。)
  
However, the operation is unconfirmed.   
(但し、動作は未確認です。)  
  
# Contact  
English Can understand, only 3-year-old level :-)  
  
# Other  
[MNIST Converter](https://github.com/TakeshiOkamoto/MNIST-Converter)
  
