# PSTree
Simple Powershell module to generate a directory tree view

```
PS  C:\My\Path> Get-Tree
.
├── sub directory
│   ├── subdir2
│   │   ├── New Text Document (2).txt
│   │   ├── New Text Document (3).txt
│   │   └── New Text Document.txt
│   └── subdir3
├── file1.txt
└── file2.txt
```

```
PS C:\Users\Lee\Desktop> Get-Tree C:\My\Path
C:\My\Path
├── sub directory
│   ├── subdir2
│   │   ├── New Text Document (2).txt
│   │   ├── New Text Document (3).txt
│   │   └── New Text Document.txt
│   └── subdir3
├── file1.txt
└── file2.txt
```
