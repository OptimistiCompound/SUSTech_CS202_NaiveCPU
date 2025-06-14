### 第一题 5个选择题 10p

1. 不难
2. 考察 Superscaler

3. 考察硬件层面不能提升的方法
   1. 超长指令 - 超标量 - 乱序执行 - 动态执行
4. TLB、page、Cache 中 hit/miss 不可能出现的情况

5. MIMD，SIMD，SISD，MISD 的辨析

### 第二题 Pipeline 8p

给出一个 4-stage pipeline （不能同时同时 ID 和 WB ）

1. 使用 stall 解决数据冲突，计算 delay
2. 增加硬件减少 delay

### 第三题 pipeline + 静态多发射 8p

1. 重排汇编指令顺序
2. 计算 IPC

### 第四题 汉明码 10p

(1) 和 (2) 计算 SEC/DED 所需的纠错码

(3) 计算 $74_{\text{ten}}$ 纠正后的六位二进制数

### 第五题 AMAT 10p

计算 hit time 和 local miss、global miss 给定的 AMAT

### 第六题 并行化 8p

一个任务，10% 串行，90% 可并行，每一个 core 提供 60% improvement，比如 5个 cores 提供 3 times的梯度提升

1. 计算 speedup
2. 计算极限状态下 speedup

### 第七题 填空题 24p

1. 两种 Hazard 名称
2. 缓存的局部性原理
3. Cache 三种 miss 的解决方法和副作用
4. 全相联缓存中，两种 find clock 方法，一种增加计算复杂性，一种需要更多存储空间
5.  MTTR 和 MTTF 得到的计算可用比例公式
6. 三种 multithreading 的名称

### 第八题 TLB 和 Cache 18p

给出 虚拟地址为32bits，物理地址为24bits，page size是8KB；Cache 是四路组相联，Cache size=，Block size=64B

1. 问了图中一系列值转移值的位宽，以及 tag 的含义

​	Cache 中 tag = 10 bits，index = 8 bits，offset = 6 bits

3. 给出一个物理内存地址，回答在 Cache 中的 index

4. Cache 从 Memory 中读取时间和 Page Fault 哪个时间长
5. 为什么 Cache 使用写直达，Page 使用写回

### 第九题 直接映射缓存 14p

给出了两个程序，遍历二维数组 `a[256][256]`， 第一个 for i { for j}

内存总大小为 256MB，Cache 有 8 个 block，64 B

1. 计算 Cache 总大小，包括 reference bit，dirty bit，tag，valid bit
2. 计算 `a[0][31]` 和 `a[1][1]` 的映射缓存 index （初始地址为`320` 十进制）
3. 计算两个程序的 hit ratio

