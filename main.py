import os
import subprocess
import socket
import tkinter as tk
from tkinter import simpledialog, ttk, messagebox, Menu

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_computer_info():
    computer_name = socket.gethostname()
    ip_address = socket.gethostbyname(computer_name)
    return f"اسم الكمبيوتر: {computer_name}\nعنوان الجهاز: {ip_address}"

def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout

def show_computer_info():
    info = get_computer_info()
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, info)

def show_system_info():
    info = run_command("systeminfo")
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, info)

def show_wmic_cpu_info():
    result = run_command("wmic cpu get name")
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, result)

def show_wmic_disk_info():
    result = run_command("wmic diskdrive get model")
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, result)

def show_wmic_os_info():
    result = run_command("wmic os get Caption, Version, BuildNumber")
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, result)

def search_running_processes():
    process_name = simpledialog.askstring("بحث عن العمليات", "أدخل اسم العملية (مثل: notepad.exe):")
    if process_name:
        result = run_command(f'tasklist | findstr /i "{process_name}"')
        text_area.delete(1.0, tk.END)
        text_area.insert(tk.END, result)

def terminate_process():
    pid = simpledialog.askstring("إنهاء عملية", "أدخل رقم العملية لإنهائها:")
    if pid:
        result = run_command(f'taskkill /PID {pid} /F')
        text_area.delete(1.0, tk.END)
        text_area.insert(tk.END, result)

def ping_ip():
    ip = simpledialog.askstring("تحقق من عنوان", "أدخل عنوان الجهاز لتجربته:")
    if ip:
        result = run_command(f'ping -n 1 {ip}')
        text_area.delete(1.0, tk.END)
        text_area.insert(tk.END, result)

def check_network_config():
    result = run_command("ipconfig /all")
    text_area.delete(1.0, tk.END)
    text_area.insert(tk.END, result)

def dns_lookup():
    hostname = simpledialog.askstring("بحث عن عنوان", "أدخل اسم المضيف:")
    if hostname:
        result = run_command(f'nslookup {hostname}')
        text_area.delete(1.0, tk.END)
        text_area.insert(tk.END, result)

def traceroute():
    target = simpledialog.askstring("تتبع المسار", "أدخل عنوان الجهاز أو اسم المضيف:")
    if target:
        result = run_command(f'tracert -d {target}')
        text_area.delete(1.0, tk.END)
        text_area.insert(tk.END, result)

def check_port():
    ip = simpledialog.askstring("التحقق من المنفذ", "أدخل عنوان الجهاز:")
    port = simpledialog.askstring("التحقق من المنفذ", "أدخل رقم المنفذ:")
    if ip and port:
        result = run_command(f'powershell -Command "try {{ $tcp = New-Object System.Net.Sockets.TcpClient; $tcp.Connect(\'{ip}\', {port}); $tcp.Close(); Write-Output \'True\' }} catch {{ Write-Output \'False\' }}"')
        text_area.delete(1.0, tk.END)
        if "True" in result:
            text_area.insert(tk.END, f"المنفذ {port} على {ip} مفتوح.")
        else:
            text_area.insert(tk.END, f"المنفذ {port} على {ip} مغلق أو غير reachable.")

def show_about():
    messagebox.showinfo("حول", "هذه الأداة تم تطويرها بواسطة وكالة التحول الرقمي بأمانة منطقة الباحة.\n\nالإصدار: 1.0")

def show_license():
    messagebox.showinfo("ترخيص", "هذا البرنامج مٌرخص بموجب رخصة جنو العمومية العامة الإصدار 2 (GPLv2). يمكنك إعادة توزيعه وتعديله وفقًا للشروط الواردة في الرخصة.  \n لمزيد من المعلومات، يمكن الاطلاع على تفاصيل التراخيص العمومية بالرابط https://www.gnu.org/licenses/.\n\n ")

def exit_app():
    root.quit()

# إنشاء واجهة المستخدم
root = tk.Tk()
root.title("أداة معلومات النظام والشبكة")
root.geometry("520x600")
root.configure(bg="#f0f0f0")

# إنشاء قائمة
menu_bar = Menu(root)
file_menu = Menu(menu_bar, tearoff=0)
file_menu.add_command(label="خروج", command=exit_app)
menu_bar.add_cascade(label="ملف", menu=file_menu)

about_menu = Menu(menu_bar, tearoff=0)
about_menu.add_command(label="حول", command=show_about)
about_menu.add_command(label="ترخيص", command=show_license)
menu_bar.add_cascade(label="حول", menu=about_menu)

root.config(menu=menu_bar)

style = ttk.Style()
style.configure("TButton", font=("Arial", 12))
style.configure("TLabel", font=("Arial", 12))
style.configure("TFrame", background="#f0f0f0")

# إنشاء منطقة النص
text_area = tk.Text(root, width=90, height=25, bg="#ffffff", fg="#000000", wrap=tk.WORD)
text_area.pack(padx=10, pady=10, fill='both', expand=True)

# إضافة شريط تمرير
scrollbar = ttk.Scrollbar(root, command=text_area.yview)
text_area['yscrollcommand'] = scrollbar.set
scrollbar.pack(side='right', fill='y')
scrollbar.pack_forget()  # Hide the scrollbar

# إنشاء إطار للخيارات
options_frame = ttk.Frame(root, padding=(10, 5))
options_frame.pack(padx=10, pady=5, fill="both")

# أزرار الخيارات
ttk.Button(options_frame, text="معلومات الكمبيوتر", command=show_computer_info).grid(row=0, column=0, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="معلومات النظام", command=show_system_info).grid(row=0, column=1, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="معلومات المعالج", command=show_wmic_cpu_info).grid(row=0, column=2, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="محركات الأقراص", command=show_wmic_disk_info).grid(row=0, column=3, padx=5, pady=5, sticky='w')

ttk.Button(options_frame, text=" نظام التشغيل", command=show_wmic_os_info).grid(row=1, column=0, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="بحث عن العمليات", command=search_running_processes).grid(row=1, column=1, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="إنهاء عملية", command=terminate_process).grid(row=1, column=2, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="تحقق من عنوان", command=ping_ip).grid(row=1, column=3, padx=5, pady=5, sticky='w')

ttk.Button(options_frame, text="التكوين الشبكي", command=check_network_config).grid(row=2, column=0, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="بحث عنوان", command=dns_lookup).grid(row=2, column=1, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="تتبع المسار", command=traceroute).grid(row=2, column=2, padx=5, pady=5, sticky='w')
ttk.Button(options_frame, text="التحقق من المنفذ", command=check_port).grid(row=2, column=3, padx=5, pady=5, sticky='w')

# إضافة تذييل
footer = tk.Label(root, text="تم بواسطة وكالة التحول الرقمي بأمانة منطقة الباحة", bg="#f0f0f0", font=("Arial", 13))
footer.pack(side="bottom", pady=5)

root.mainloop()
