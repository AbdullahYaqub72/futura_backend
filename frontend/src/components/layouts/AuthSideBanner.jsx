import bgImage from '../../assets/auth/login_BG.png'
import icon from '../../assets/auth/login_icon.png'

const AuthSideBanner = () => {
    return (
      <div className="w-1/2 h-screen flex flex-col justify-between p-[3rem] text-white bg-[linear-gradient(to_bottom,#7081F9_0%,#6578F9_8%,#2F42C2_100%)]">
        <div className="font-medium text-3xl">Fuatra - Track. Manage. Grow</div>
        <div className="w-full h-fit flex justify-center items-center">
          <img src={bgImage} className="w-[80%]" />
        </div>
        <div className="w-full flex justify-center space-x-[1rem] text-sm">
          <img src={icon} className="w-fit h-fit object-contain" />
          <span>Trusted by thousands of finance teams and employees</span>
        </div>
      </div>
    );
  };

export default AuthSideBanner;