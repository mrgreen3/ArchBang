from archinstall.default_profiles.profile import ProfileType
from archinstall.default_profiles.xorg import XorgProfile
import subprocess
import os


class ArchBangProfile(XorgProfile):
    def __init__(self) -> None:
        super().__init__('ArchBang', ProfileType.WindowMgr, description='ArchBang minimal Openbox environment')
        print("ArchBang profile initialized with packages:", self.packages)

    @property
    def packages(self) -> list[str]:
        # Include only Openbox here; additional packages handled in Bash script
        return ['openbox']

    @property
    def default_greeter_type(self) -> None:
        # No greeter is required for ArchBang
        return None

    def post_install(self, installation: object) -> None:
        print("ArchBang post_install triggered.")

        # Path to the Bash script
        script_path = "/home/ablive/.config/archinstall/ab_install"

        # Ensure the script exists
        if not os.path.exists(script_path):
            print(f"Error: Bash script not found: {script_path}")
            return

        # Execute the Bash script
        try:
            print(f"Executing bash script: {script_path}")
            subprocess.run(["bash", script_path], check=True)
            print("Bash script executed successfully.")
        except subprocess.CalledProcessError as e:
            print(f"Error occurred while executing the bash script: {e}")

