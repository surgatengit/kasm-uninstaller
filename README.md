# Kasm Uninstaller Script

This script completely removes [Kasm Workspaces](https://www.kasmweb.com/) from a Linux server.

Bonus: One line installer with swap and no iteraction.
```bash
cd /tmp && curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.bbc15c.tar.gz && tar -xf kasm_release_1.17.0.bbc15c.tar.gz && sudo bash kasm_release/install.sh --accept-eula --swap-size 8192
```

### ✅ Features
- Automatically detects the installed version of Kasm.
- Removes containers, volumes, networks, and images created by Kasm.
- Deletes associated system users.
- Logs the full uninstallation process to `/tmp/kasm_uninstall.log`.

---

## 🚀 Usage

1. Clone the repository:

```bash
git clone https://github.com/yourusername/kasm-uninstaller.git
```

2. Make the script executable:

```bash
cd kasm-uninstaller
chmod +x uninstall_kasm.sh
```

3. Run the script with `sudo`:

```bash
sudo ./uninstall_kasm.sh
```

> 📝 A detailed log will be saved to `/tmp/kasm_uninstall.log`

---

## ⚠️ Warning

This script will **completely uninstall Kasm Workspaces** and remove all its Docker-related resources and system files. Use at your own risk.

### 🔧 Direct command to run the script on your server (without manual download):

Run it directly with:

```bash
bash <(curl -s https://raw.githubusercontent.com/surgatengit/kasm-uninstaller/refs/heads/main/uninstall_kasm.sh)
```

Or download and run it locally:

```bash
curl -O https://raw.githubusercontent.com/surgatengit/kasm-uninstaller/refs/heads/main/uninstall_kasm.sh
chmod +x uninstall_kasm.sh
sudo ./uninstall_kasm.sh
```
