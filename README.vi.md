# ROS-Scripts
Dự án Router-OS Script (Mikrotik) cho Crossian.

[![Lang EN](https://img.shields.io/badge/lang-en-yellow)](https://github.com/quachdoduy/ROS-Scripts/blob/main/README.md)
[![Lang VI](https://img.shields.io/badge/lang-vi-green)](https://github.com/quachdoduy/ROS-Scripts/blob/main/README.vi.md)<br/>
[![GitHub stars](https://img.shields.io/github/stars/quachdoduy/ROS-Scripts?logo=GitHub&style=flat&color=red)](https://github.com/quachdoduy/ROS-Scripts/stargazers)
[![GitHub watchers](https://img.shields.io/github/watchers/quachdoduy/ROS-Scripts?logo=GitHub&style=flat&color=blue)](https://github.com/quachdoduy/ROS-Scripts/watchers)<br/>
[![donate with paypal](https://img.shields.io/badge/Like_it%3F-Donate!-green?logo=githubsponsors&logoColor=orange&style=flat)](https://paypal.me/quachdoduy)
[![donate with buymeacoffe](https://img.shields.io/badge/Like_it%3F-Donate!-blue?logo=githubsponsors&logoColor=orange&style=flat)](https://buymeacoffee.com/quachdoduy)

>Nếu bạn có bất kỳ ý tưởng kịch bản nào hoặc chỉ muốn chia sẻ ý kiến ​​của mình, bạn có thể [Thảo luận](https://github.com/quachdoduy/ROS-Scripts/discussions/) hoặc mở [Vấn đề](https://github.com/quachdoduy/ROS-Scripts/issues) nếu bạn tìm thấy bất kỳ lỗi nào.

# MỤC LỤC
- [Mục lụclục](#mục-lục)
- [Ý tưởng ban đầu](#ý-tưởng-ban-đầu)
- [Đặc trưng](#đặc-trưng)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Thiết lập ban đầu](#thiết-lập-ban-đầu)
    - [Trước khi cài đặt](#trước-khi-cài-đặt)
    - [Cài đặt](#cài-đặt)
- [Giai đoạn tiếp theo](#giai-đoạn-tiếp-theo)

# Ý tưởng ban đầu
- Tự động giám sát các kết nối WAN của thiết bị và gửi cảnh báo đến Telegram và Slack.
- Viết các tập lệnh với phương pháp tập trung và có thể tái sử dụng cho các tập lệnh riêng lẻ nhỏ hơn.

# Đặc trưng
- Kênh thông báo (Có thể lựa chọn)
    - **Thông báo qua email**: Gửi cảnh báo đến email đã cấu hình.
    - **Thông báo qua Telegram**: Gửi cảnh báo đến tài khoản Telegram đã cấu hình.
    - **Thông báo qua Webhook**: Gửi cảnh báo đến webhook đã cấu hình. Webhook được sử dụng rộng rãi vì nhiều ứng dụng sử dụng chúng làm cổng dữ liệu trước khi xử lý.
- Ghi nhật ký
    - Ghi nhật ký tất cả các hoạt động được thực hiện trên thiết bị để theo dõi trong tương lai.
- Giám sát tình trạng hệ thống
    - Trạng thái kết nối WAN: Giám sát trạng thái kết nối của các giao diện WAN.
    - Trạng thái bộ nguồn (PSU): Kiểm tra trạng thái của các nguồn điện.
    - Giám sát hiệu suất:
        - Tải CPU: Cảnh báo khi sử dụng CPU > 80%.
        - Sử dụng RAM: Cảnh báo khi sử dụng RAM > 75%.
        - Sử dụng HDD: Cảnh báo khi sử dụng lưu trữ > 65%.
        - Giám sát nhiệt độ:
            - Nhiệt độ CPU & Bo mạch chủ:
                - Cảnh báo: 60-75°C
                - Báo động: Trên 75°C
    *Tất cả cảnh báo đều có tiếng "bíp" phát ra từ loa bo mạch chủ.*
- Khởi động thiết bị
    - Thông báo về quá trình khởi động thiết bị.
    - Sao lưu cấu hình thiết bị.
    - Khởi động lại thiết bị.

# Yêu cầu hệ thống
1. Phần mềm
    - RouterOS
    Tập lệnh được viết cho RouterOS `7.n` (cụ thể là RouterOS `7.15.2`). Đảm bảo khả năng tương thích ngược với RouterOS `6.n` và các phiên bản thấp hơn.
    - Script này được viết bằng Visual Code của Microsoft với các phần mở rộng tương thích.
        - [Visual Code](https://code.visualstudio.com/download)
        - [Extensions](https://github.com/devMikeUA/vscode_mikrotik_routeros_script)
2. Phần cứng
Tập lệnh có thể tăng kích thước khi cập nhật. Hãy thận trọng với các thiết bị có dung lượng lưu trữ 16MB hoặc thấp hơn.
*Các tệp cấu hình có thể tăng theo thời gian, do đó, nên theo dõi thường xuyên.*

# Thiết lập ban đầu
## Trước khi cài đặt
*Thông tin cần chuẩn bị trước khi cài đặt.*
1. **Tên viết tắt của tổ chức**: Được lưu trữ trong biến **varCustomName**
    - Ví dụ: `:global varCustomName "Customer ABC XYZ";`
2. **Phương pháp thông báo**: Được lưu trữ trong biến **arrSendNotify**
    - Ví dụ: `:global arrSendNotify {"email";"telegram";"webhook"};`
    - *Cài đặt cho từng phương pháp cảnh báo sẽ được cấu hình trong* **GlobalConfig.rsc**.
3. **Cấu hình giám sát WAN**:
    - Số lượng WAN: Được lưu trữ trong biến **arrWANname**
        - Ví dụ: `:global arrWANname {"WAN-1";"WAN-2"};`
    - Tên giao diện WAN: Được lưu trữ trong biến **arrWANinterface**
        - Ví dụ: `:global arrWANinterface {"pppoe-out1";"pppoe-out2"};`
    - Địa chỉ IPv4 Next-Hop của WAN: Được lưu trữ trong biến **arrWANnexthop**
        - Ví dụ: `:global arrWANnexthop {"8.8.8.8";"8.8.4.4"};`
4. **Cấu hình giám sát nguồn điện**:
    - Số lượng PSU: Được lưu trữ trong biến **arrPSUname**
        - Ví dụ: `:global arrPSUname {"PSU-1";"PSU-2"};`
    - PSU ID trong Bảng SystemHealth: Được lưu trữ trong biến **arrPSUhealthID**
        - Ví dụ: `:global arrPSUhealthID {"8";"9"};`
5. **Cấu hình giám sát nhiệt độ**:
    - Số lượng nguồn nhiệt độ: Được lưu trữ trong biến **arrTemperature**
        - Ví dụ: `:global arrTemperature {"Board-Temperature";"CPU-Temperature";"Switch-Temperature"};`
    - ID cảm biến nhiệt độ trong bảng SystemHealth: Được lưu trữ trong biến **arrTemperatureID**
        - Ví dụ: `:global arrTemperatureID {"7";"0";"1"};`
## Cài đặt
- Cấu hình các thiết lập mạng cơ bản trên bộ định tuyến với IP đã chọn, đảm bảo khả năng truyền tệp.
- Tải lên **InitialSetup.rsc** và nhập nó bằng cách sử dụng:
```bash
/import InitialSetup.rsc;
```
- Cập nhật và lưu các cấu hình trong tập lệnh **GlobalConfig**.
- Thực thi tập lệnh để cập nhật các biến môi trường: 
```bash
/system/script/run GlobalConfig;
```

# Giai đoạn tiếp theo
- **Chức năng kiểm tra lần chạy đầu tiên**: Đảm bảo kiểm tra trạng thái sau mỗi lần khởi động lại. **(Hoàn thành: 10/02/2025)**
- **Thiết lập bộ lập lịch tự động ban đầu**: **(Hoàn thành: 10/02/2025)**
- Chức năng cập nhật cấu hình nâng cao: Giảm thiểu các sửa đổi tập lệnh trực tiếp.

*[Lên đầu trang](#ros-scripts)*