import sys
import os
import subprocess
import ctypes
import winreg
from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QCheckBox,
    QPushButton, QLabel, QProgressBar, QMessageBox, QStackedWidget, QListWidget,
    QListWidgetItem, QSizePolicy, QSpacerItem
)
from PyQt6.QtCore import Qt, QThread, pyqtSignal, QSize
from PyQt6.QtGui import QFont, QIcon, QPalette, QColor

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

class OptimizationWorker(QThread):
    progress = pyqtSignal(str, int)  # message, percent
    finished = pyqtSignal()
    error = pyqtSignal(str)

    def __init__(self, options):
        super().__init__()
        self.options = options

    def run(self):
        try:
            if not is_admin():
                self.error.emit("Administrator privileges are required. Please run the application as administrator.")
                return

            steps = []
            if self.options.get('network_fixes', False):
                steps.append(('Applying network fixes...', self.network_fixes))
            if self.options.get('system_repair', False):
                steps.append(('Running system file repair...', self.system_repair))
            if self.options.get('cleanup', False):
                steps.append(('Cleaning temporary files...', self.cleanup_files))
            if self.options.get('performance', False):
                steps.append(('Applying performance tweaks...', self.apply_performance_tweaks))
            if self.options.get('privacy', False):
                steps.append(('Adjusting privacy settings...', self.apply_privacy_settings))

            total = len(steps)
            for idx, (msg, func) in enumerate(steps, 1):
                percent = int((idx - 1) / total * 100)
                self.progress.emit(msg, percent)
                func()
            self.progress.emit("All tasks complete!", 100)
            self.finished.emit()
        except Exception as e:
            self.error.emit(str(e))

    def run_command(self, command):
        creationflags = 0x08000000 if sys.platform == 'win32' else 0
        process = subprocess.Popen(
            command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, creationflags=creationflags
        )
        stdout, stderr = process.communicate()
        if process.returncode != 0:
            raise Exception(
                f"Command failed: {command}\n"
                f"Stdout: {stdout.decode(errors='ignore')}\n"
                f"Stderr: {stderr.decode(errors='ignore')}"
            )

    def network_fixes(self):
        self.run_command("ipconfig /flushdns")
        self.run_command("netsh winsock reset")
        self.run_command("netsh int ip reset")

    def system_repair(self):
        self.run_command("DISM /Online /Cleanup-Image /RestoreHealth")
        self.run_command("sfc /scannow")

    def cleanup_files(self):
        temp_paths = [
            os.environ.get('TEMP'),
            os.path.join(os.environ.get('SystemRoot', 'C:\\Windows'), 'Temp')
        ]
        for path in temp_paths:
            if path and os.path.exists(path):
                for item in os.listdir(path):
                    try:
                        item_path = os.path.join(path, item)
                        if os.path.isfile(item_path):
                            os.unlink(item_path)
                        elif os.path.isdir(item_path):
                            import shutil
                            shutil.rmtree(item_path)
                    except Exception as e:
                        print(f"Error deleting {item_path}: {e}")
        self.run_command("cleanmgr /verylowdisk /d C:")

    def apply_performance_tweaks(self):
        key_path = r"Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
        try:
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, key_path, 0, winreg.KEY_WRITE) as key:
                winreg.SetValueEx(key, "VisualFxSetting", 0, winreg.REG_DWORD, 2)
        except Exception as e:
            print(f"Error applying visual effects tweak: {e}")

    def apply_privacy_settings(self):
        key_path = r"SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        try:
            with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, key_path) as key:
                winreg.SetValueEx(key, "AllowTelemetry", 0, winreg.REG_DWORD, 0)
        except Exception as e:
            print(f"Error applying privacy settings: {e}")

class SectionPage(QWidget):
    def __init__(self, title, options):
        super().__init__()
        self.title = title
        self.checkboxes = []
        layout = QVBoxLayout(self)
        label = QLabel(f"<b>{title}</b>")
        label.setFont(QFont("Segoe UI", 14))
        layout.addWidget(label)
        for opt in options:
            cb = QCheckBox(opt)
            cb.setFont(QFont("Segoe UI", 11))
            self.checkboxes.append(cb)
            layout.addWidget(cb)
        layout.addItem(QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding))

    def get_states(self):
        return [cb.isChecked() for cb in self.checkboxes]

    def set_states(self, states):
        for cb, state in zip(self.checkboxes, states):
            cb.setChecked(state)

class SummaryPage(QWidget):
    def __init__(self, section_pages):
        super().__init__()
        self.section_pages = section_pages
        layout = QVBoxLayout(self)
        self.summary_label = QLabel()
        self.summary_label.setFont(QFont("Segoe UI", 12))
        layout.addWidget(self.summary_label)
        layout.addItem(QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding))

    def update_summary(self):
        summary = "<b>Selected Optimizations:</b><br>"
        for page in self.section_pages:
            checked = [cb.text() for cb in page.checkboxes if cb.isChecked()]
            if checked:
                summary += f"<u>{page.title}</u>:<br>" + "<br>".join(f"&nbsp;&nbsp;• {c}" for c in checked) + "<br>"
        self.summary_label.setText(summary)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Windows Optimizer")
        self.setMinimumSize(900, 600)
        self.setFont(QFont("Segoe UI", 10))
        self.set_dark_palette()

        # Set a built-in Qt icon
        self.setWindowIcon(self.style().standardIcon(self.style().StandardPixmap.SP_ComputerIcon))

        # Sidebar navigation
        nav_widget = QListWidget()
        nav_widget.setFixedWidth(180)
        nav_widget.setFont(QFont("Segoe UI", 11))
        nav_widget.setStyleSheet("QListWidget { background: #23272e; color: #fff; border: none; } QListWidget::item:selected { background: #3a3f4b; }")
        nav_items = ["Network", "System Repair", "Cleanup", "Performance", "Privacy", "Summary"]
        for item in nav_items:
            QListWidgetItem(item, nav_widget)
        nav_widget.setCurrentRow(0)

        # Pages
        self.pages = [
            SectionPage("Network Optimization", ["Reset network configurations (IP, Winsock)"]),
            SectionPage("System Repair", ["Repair Windows system files (DISM, SFC)"]),
            SectionPage("System Cleanup", ["Clean temporary files and optimize disk"]),
            SectionPage("Performance Optimization", ["Apply performance tweaks (Visual Effects, Power Plan)"]),
            SectionPage("Privacy Settings", ["Adjust privacy settings and disable telemetry"])
        ]
        self.summary_page = SummaryPage(self.pages)

        self.stacked = QStackedWidget()
        for page in self.pages:
            self.stacked.addWidget(page)
        self.stacked.addWidget(self.summary_page)

        nav_widget.currentRowChanged.connect(self.stacked.setCurrentIndex)
        nav_widget.currentRowChanged.connect(self.update_summary_if_needed)

        # Header
        header = QLabel("Windows Optimizer")
        header.setFont(QFont("Segoe UI", 18, QFont.Weight.Bold))
        header.setAlignment(Qt.AlignmentFlag.AlignCenter)
        header.setStyleSheet("color: #fff; background: #23272e; padding: 12px;")

        # Footer
        self.status_bar = QLabel()
        self.status_bar.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.status_bar.setStyleSheet("color: #fff; background: #23272e; padding: 6px;")
        self.progress_bar = QProgressBar()
        self.progress_bar.setVisible(False)
        self.progress_bar.setStyleSheet("""
            QProgressBar {
                border: 1px solid #444;
                border-radius: 5px;
                background: #23272e;
                color: #fff;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #7c4dff;
                width: 20px;
            }
        """)

        # Buttons
        self.start_button = QPushButton("Start Optimization")
        self.start_button.setFont(QFont("Segoe UI", 12, QFont.Weight.Bold))
        self.start_button.setStyleSheet("background: #7c4dff; color: #fff; padding: 8px 24px; border-radius: 6px;")
        self.start_button.clicked.connect(self.start_optimization)

        self.select_all_button = QPushButton("Select All")
        self.select_all_button.setFont(QFont("Segoe UI", 12))
        self.select_all_button.setStyleSheet("background: #444; color: #fff; padding: 8px 24px; border-radius: 6px;")
        self.select_all_button.clicked.connect(self.select_all)

        button_layout = QHBoxLayout()
        button_layout.addWidget(self.start_button)
        button_layout.addWidget(self.select_all_button)
        button_layout.addStretch()

        # Main layout
        main_widget = QWidget()
        main_layout = QVBoxLayout(main_widget)
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.addWidget(header)
        content_layout = QHBoxLayout()
        content_layout.addWidget(nav_widget)
        content_layout.addWidget(self.stacked, 1)
        main_layout.addLayout(content_layout)
        main_layout.addWidget(self.progress_bar)
        main_layout.addWidget(self.status_bar)
        main_layout.addLayout(button_layout)
        self.setCentralWidget(main_widget)

        if not is_admin():
            QMessageBox.critical(self, "Administrator Rights Required",
                "This application requires administrator privileges to run properly.\n"
                "Please right-click and run as administrator.")

    def set_dark_palette(self):
        palette = QPalette()
        palette.setColor(QPalette.ColorRole.Window, QColor(35, 39, 46))
        palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.Base, QColor(35, 39, 46))
        palette.setColor(QPalette.ColorRole.AlternateBase, QColor(44, 49, 60))
        palette.setColor(QPalette.ColorRole.ToolTipBase, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.ToolTipText, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.Button, QColor(44, 49, 60))
        palette.setColor(QPalette.ColorRole.ButtonText, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.BrightText, Qt.GlobalColor.red)
        palette.setColor(QPalette.ColorRole.Highlight, QColor(124, 77, 255))
        palette.setColor(QPalette.ColorRole.HighlightedText, Qt.GlobalColor.white)
        QApplication.instance().setPalette(palette)

    def select_all(self):
        for page in self.pages:
            for cb in page.checkboxes:
                cb.setChecked(True)

    def update_summary_if_needed(self, idx):
        if idx == len(self.pages):  # Summary page
            self.summary_page.update_summary()

    def start_optimization(self):
        options = {
            'network_fixes': self.pages[0].checkboxes[0].isChecked(),
            'system_repair': self.pages[1].checkboxes[0].isChecked(),
            'cleanup': self.pages[2].checkboxes[0].isChecked(),
            'performance': self.pages[3].checkboxes[0].isChecked(),
            'privacy': self.pages[4].checkboxes[0].isChecked()
        }
        if not any(options.values()):
            QMessageBox.warning(self, "No Options Selected",
                "Please select at least one optimization option.")
            return

        self.start_button.setEnabled(False)
        self.select_all_button.setEnabled(False)
        self.progress_bar.setVisible(True)
        self.progress_bar.setRange(0, 100)
        self.progress_bar.setValue(0)

        self.worker = OptimizationWorker(options)
        self.worker.progress.connect(self.update_status)
        self.worker.finished.connect(self.optimization_finished)
        self.worker.error.connect(self.optimization_error)
        self.worker.start()

    def update_status(self, message, percent):
        self.status_bar.setText(f"{message} ({percent}%)")
        self.progress_bar.setValue(percent)

    def optimization_finished(self):
        self.progress_bar.setVisible(False)
        self.start_button.setEnabled(True)
        self.select_all_button.setEnabled(True)
        self.status_bar.setText("Optimization completed successfully! (100%)")
        QMessageBox.information(self, "Optimization Complete",
            "The selected optimizations have been completed.\n"
            "Some changes may require a system restart to take effect.")

    def optimization_error(self, error_message):
        self.progress_bar.setVisible(False)
        self.start_button.setEnabled(True)
        self.select_all_button.setEnabled(True)
        self.status_bar.setText("Error occurred during optimization")
        QMessageBox.critical(self, "Optimization Error",
            f"An error occurred during optimization:\n{error_message}")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())