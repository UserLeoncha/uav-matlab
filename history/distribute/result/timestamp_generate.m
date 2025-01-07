function formattedString = timestamp_generate()
%TIMSTAMP_GENERATE 此处显示有关此函数的摘要
%   此处显示详细说明
% 设置输出格式
timestamp = datetime('now', 'TimeZone', 'UTC') - datetime('1970-01-01 00:00:00', 'TimeZone', 'UTC');
timestamp = seconds(timestamp);
% 将时间戳转换为日期时间对象
dt = datetime(timestamp, 'ConvertFrom', 'posixtime');
% 格式化日期时间为所需字符串格式
formattedString = sprintf('%04d%02d%02d%02d%02d', ...
    year(dt), month(dt), day(dt), hour(dt), minute(dt));
end

