import { Icon } from "@iconify/react";

const Button = ({ children, onClick, type = "button", className = "", disabled = false, bgColor = "bg-[#6578F9]", textColor = "text-white", hoverColor = "hover:bg-[#5568d9]", disabledColor = "disabled:bg-gray-400", icon }) => {
  return (
    <button
      onClick={onClick}
      type={type}
      disabled={disabled}
      className={`w-full flex items-center justify-center space-x-2 ${bgColor} p-3 shadow-md ${textColor} rounded-md transition-all duration-300 ${hoverColor} disabled:cursor-not-allowed ${disabledColor} ${className}`}
    >
      {icon && <Icon icon={icon} className="w-5 h-5" />}
      <span>{children}</span>
    </button>
  );
};

export default Button;
