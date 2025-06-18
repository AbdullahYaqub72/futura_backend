import { Icon } from "@iconify/react";

const FormInput = ({ label, type = "text", icon: icon_slug, noLabel = false, className = "", ...props }) => {
  return (
    <div className={`flex flex-col w-fit ${className}`}>
      {!noLabel && (
        <label className="text-[0.8rem] font-medium bg-white text-[#949494] ml-[0.5rem] px-[0.5rem] w-fit z-10 transition-colors peer-focus:text-[#6578F9]">
          {label}
        </label>
      )}
      <div className="relative w-fit">
        <input
          type={type}
          className="w-full pr-10 border border-[#E9E9E9] px-3 py-[0.6rem] focus:border-[#6578F9] peer placeholder:text-sm text-sm"
          {...props}
        />
        {icon_slug && (
          <Icon icon={icon_slug} className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
        )}
      </div>
    </div>
  );
};

export default FormInput;
