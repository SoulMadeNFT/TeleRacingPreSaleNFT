需要注意的点
在nftstorefront/get_sale_count里面不能有重复挂单
推荐使用transaction中的nftstorefront/create_listing_remove.cdc来创建挂单

因为这个函数比单纯创建挂单会多一步检查对相同的nftID是否有重复挂单
如果有的话 则会给它取消掉.


> 大概回想了一下, 在purchasebyName那里 如果有重复挂单 而且还被买掉的话, 可能微微问题


💕重点是, 我认为 对同一个id的挂单, 就不能存在重复的