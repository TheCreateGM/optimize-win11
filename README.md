# Windows Optimization Tools

A collection of Windows troubleshooting and optimization tools including both a comprehensive batch script and a modern Python GUI application.

## 🚨 **CRITICAL SECURITY WARNING**

**These tools contain potentially dangerous operations that could damage your system, compromise security, or cause data loss. Use with extreme caution.**

## 📦 Tools Included

### 1. Batch Script (`autorun.bat`) - Advanced Windows Troubleshoot & Optimize Tool v2.1
### 2. Python GUI Application (`win_optimizer.py`) - Modern Windows Optimizer

---

## 🖥️ Python GUI Application

### Features
- **Modern Dark Theme Interface**: Clean, professional design with intuitive navigation
- **Safe Operation Mode**: Implements basic optimizations without aggressive system modifications
- **Real-time Progress Tracking**: Visual progress bar and status updates
- **Administrator Privilege Checking**: Ensures proper permissions before execution
- **Modular Approach**: Choose specific optimization categories

### GUI Sections:
1. **Network Optimization**: Reset network configurations, flush DNS, reset Winsock
2. **System Repair**: Run DISM and SFC to repair system files
3. **System Cleanup**: Clean temporary files and run disk cleanup
4. **Performance Optimization**: Apply basic visual effects and power plan tweaks
5. **Privacy Settings**: Reduce telemetry and adjust privacy settings
6. **Summary**: Review selected optimizations before execution

### Prerequisites for GUI:
```
Python 3.8+
PyQt6==6.6.1
psutil==5.9.8
wmi==1.5.1
pywin32==306
```

### Installation:
```bash
pip install -r requirements.txt
python win_optimizer.py
```

### Usage:
1. Run as Administrator: `Right-click → Run as administrator`
2. Navigate through sections using the sidebar
3. Select desired optimizations
4. Review selections in Summary tab
5. Click "Start Optimization"

---

## 🔧 Batch Script (`autorun.bat`)

### ⚠️ **EXTREME CAUTION REQUIRED**

**This batch script performs aggressive system modifications that can be dangerous.**

### Critical Risks:
- **Modifies critical registry keys** without backup
- **Disables security services** (potentially including Windows Defender components)
- **Deletes system files and logs** that may be needed for recovery
- **No automatic rollback mechanism**
- **Can cause system instability or boot issues**

### What the Batch Script Does:

#### Section 1: Network Fixes
- Flushes DNS resolver cache
- Releases and renews IP configuration
- Resets Winsock catalog and TCP/IP stack
- **⚠️ Optional**: Complete firewall reset (removes ALL custom rules)

#### Section 2: System File & Disk Health
- Runs DISM repair operations
- Executes System File Checker (SFC)
- Schedules thorough Check Disk on next reboot

#### Section 3: OS Optimization & Cleanup
- Aggressive temporary file cleanup
- Clears Windows Update cache
- Disables Fast Startup
- **⚠️ Optional**: Clears display configuration cache (can cause boot issues)
- Forces Explorer restart
- Drive optimization

#### Section 4: Performance Tweaks
- **⚠️ Optional**: Disables visual effects and animations
- **⚠️ Optional**: Disables transparency effects
- **⚠️ Optional**: Forces high-performance power plan

#### Section 5: Privacy & Services (HIGH RISK)
- **⚠️ Optional**: Disables Windows telemetry
- **⚠️ Optional**: Disables DiagTrack service
- **⚠️ Optional**: Disables CEIP tasks
- **⚠️ Optional**: Disables Cortana
- **⚠️ Optional**: Disables Windows Search (makes search unusable)
- **⚠️ Optional**: Disables Superfetch/Sysmain

#### Section 6: Memory Optimization
- Provides guidance only (no automated actions)

#### Section 7: Update Maintenance (HIGH RISK)
- **⚠️ Optional**: Resets Windows Update components
- **⚠️ Optional**: Triggers update scan

#### Section 8: BSOD Troubleshooting
- Information and manual diagnostic guidance only

#### Section 9: Network Optimization
- Additional network guidance

#### Section 10: Disk Cleanup (HIGH RISK)
- **⚠️ Deletes system logs** (may be needed for troubleshooting)
- **⚠️ Clears browser data** (may cause data loss)
- Empties recycle bin

---

## 🛡️ Safety Recommendations

### Before Using Either Tool:

1. **Create a Complete System Backup**
2. **Create a System Restore Point**
3. **Have Windows Installation Media Ready**
4. **Test on a Non-Production System First**
5. **Understand Each Operation Before Proceeding**

### Recommended Approach:

1. **Start with the Python GUI**: It's safer and more conservative
2. **Avoid the batch script unless absolutely necessary**
3. **If using the batch script, only run sections 1-3**
4. **Never run all sections of the batch script at once**

---

## 🔄 Recovery Options

### If System Issues Occur:

1. **Boot into Safe Mode**
2. **Use System Restore** to revert to pre-optimization state
3. **Run Windows Recovery Environment**
4. **Use Windows Installation Media for repair**

### Service Recovery:
- Open `services.msc` as administrator
- Find disabled services and re-enable them
- Set startup type to "Automatic" or "Manual" as needed

---

## 📋 System Requirements

- **Operating System**: Windows 10 (1903+) or Windows 11
- **RAM**: 4GB minimum (8GB recommended)
- **Storage**: 10GB free space
- **Permissions**: Administrator privileges required
- **Python**: 3.8+ (for GUI application)

---

## 🎯 Recommendations by User Type

### **Casual Users**: 
- Use **Python GUI only**
- Select only Network and System Repair options
- Avoid privacy/service modifications

### **Power Users**:
- Start with Python GUI
- If needed, use batch script sections 1-3 only
- Always create restore points

### **IT Professionals**:
- Review all code before execution
- Test on isolated systems first
- Have comprehensive recovery plan
- Consider individual section execution

---

## 🆘 Emergency Contacts

### If System Becomes Unstable:
1. **Windows Recovery Environment**: Boot from installation media
2. **Safe Mode**: F8 during boot or Settings → Recovery
3. **System Restore**: Restore to pre-optimization state
4. **Professional Help**: Contact qualified IT support

---

## 📄 Legal Disclaimer

**These tools are provided "AS-IS" without warranty of any kind. The authors are not responsible for any damage, data loss, security vulnerabilities, or system instability that may result from using these tools.**

### Important Notes:
- **Not officially supported by Microsoft**
- **May void system warranties**
- **Use at your own risk**
- **Regular maintenance is safer than aggressive optimization**

---

## 🔍 Version Information

- **Python GUI**: v1.0 - Modern, safe optimization tool
- **Batch Script**: v2.1 - Advanced but potentially dangerous system modifications

---

## 📞 Support

- **No official support provided**
- **Use at your own risk**
- **Consider professional IT consultation for critical systems**
- **Community forums may provide assistance**

**Remember: The best optimization is often no optimization. Modern Windows systems are generally well-optimized out of the box.**