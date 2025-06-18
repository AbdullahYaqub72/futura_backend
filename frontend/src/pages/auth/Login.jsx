import React, { useEffect, useState } from 'react'
import googleIcon from '../../assets/auth/google.png'
import Button from '../../components/common/Button';
import FormInput from '../../components/forms/FormInput';
import { supabase } from '../../SupabaseClient'
import AuthSideBanner from '../../components/layouts/AuthSideBanner';


function Login() {
    const [session, setSession] = useState(null)

    useEffect(() => {
        supabase.auth.getSession().then(({ data: { session } }) => {
          setSession(session)
        })
        const {
          data: { subscription },
        } = supabase.auth.onAuthStateChange((_event, session) => {
          setSession(session)
        })
        return () => subscription.unsubscribe()
    }, [])
    
    const SignUpWithGoogle = async() =>{
        const response = await supabase.auth.signInWithOAuth({
            provider: "google"
        })

        console.log(response)
    }
    
    const formFields = [
        { label: "Phone", type: "text", placeholder: "Enter your phone", icon: "mage:user" },
        { label: "Email", type: "email", placeholder: "Enter your email", icon: "oui:email" },
        { label: "Password", type: "password", placeholder: "Enter your password", icon: "solar:lock-password-linear" },
    ];
    

  return (
    <div class="w-screen h-screen flex font-sans">
        <AuthSideBanner/>
        <div class="w-1/2 h-screen flex justify-center items-center">
            <div class="w-[60%] flex flex-col space-y-[3rem]">
                <div class="flex flex-col space-y-[1rem]">
                    <text class='text-2xl font-bold'>Login to your account</text>
                    <text class='text-sm text-[#AAADB4]'>New  User? <a class="text-[#6578F9]">Sign Up Here</a></text>
                </div>
                <div class="w-full flex flex-col space-y-6">
                    <button onClick={SignUpWithGoogle} class="w-full flex justify-center items-center space-x-[1.3rem] bg-white p-3 rounded-lg shadow-md border border-[#AAADB4] text-center font-medium">
                        <img src={googleIcon}/>
                        <text>Login with Google</text>
                    </button>

                    <div class="w-full flex items-center space-x-2">
                        <div class="flex-1 h-[1px] bg-[#AAADB4]"></div>
                        <span class="text-[#AAADB4] text-sm whitespace-nowrap">or Login with Email</span>
                        <div class="flex-1 h-[1px] bg-[#AAADB4]"></div>
                    </div>
                </div>
                <div className="w-full flex flex-col space-y-[2rem]">
                    {formFields.map((field, index) => (
                        <FormInput key={index} {...field} />
                    ))}
                </div>
                <div class='w-full flex space-x-[0.8rem] items-center text-sm'>
                    <input type='checkbox'/>
                    <text>I agree to the <a class="text-[#6578F9]">Terms & Conditions</a></text>
                </div>
                <Button bgColor="bg-[#6578F9]" textColor="text-white" hoverColor="hover:bg-[#5568d9]">
                    Login
                </Button>
            </div>
        </div>
    </div>
  )
}

export default Login