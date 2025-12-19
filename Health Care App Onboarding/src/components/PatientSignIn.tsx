import { useState } from 'react';
import { motion } from 'motion/react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Mail, Lock } from 'lucide-react';
import logo from 'figma:asset/67deb029e390c772cc33e8e748e86b0188280ecc.png';

export default function PatientSignIn() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    alert('Sign in successful! Welcome back.');
  };

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-6 relative overflow-hidden">
      {/* Background logo with blur and 3D effect */}
      <div className="absolute inset-0 flex items-center justify-center">
        <motion.div
          animate={{
            scale: [1, 1.05, 1],
            rotateY: [0, -5, 0],
          }}
          transition={{
            duration: 8,
            repeat: Infinity,
            ease: "easeInOut",
          }}
          className="opacity-5 blur-md"
          style={{ transform: 'perspective(1000px)' }}
        >
          <img src={logo} alt="" className="w-[700px] h-auto" />
        </motion.div>
      </div>

      {/* Grid overlay */}
      <div className="absolute inset-0 opacity-5">
        <div className="w-full h-full" style={{
          backgroundImage: 'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
          backgroundSize: '50px 50px'
        }} />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="relative z-10 w-full max-w-md"
      >
        {/* Back button */}
        <button
          onClick={() => navigate('/role-selection')}
          className="mb-6 flex items-center gap-2 text-gray-400 hover:text-white transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        {/* Glass card */}
        <div className="rounded-3xl border border-white/10 backdrop-blur-2xl bg-white/5 p-8 shadow-2xl">
          {/* Header */}
          <div className="text-center mb-8">
            <h2 className="text-white mb-2">Patient Sign In</h2>
            <p className="text-gray-400">Welcome back to Medi Nexus</p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label className="block text-gray-300 mb-2 text-sm">Email</label>
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Enter your email"
                  className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-gray-300 mb-2 text-sm">Password</label>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
                  className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                  required
                />
              </div>
            </div>

            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center gap-2 text-gray-400 cursor-pointer">
                <input
                  type="checkbox"
                  className="w-4 h-4 rounded bg-white/5 border border-white/10 focus:outline-none"
                />
                Remember me
              </label>
              <button type="button" className="text-gray-400 hover:text-white transition-colors">
                Forgot password?
              </button>
            </div>

            <button
              type="submit"
              className="w-full py-4 rounded-xl bg-white text-black hover:bg-gray-200 transition-colors"
            >
              Sign In
            </button>
          </form>

          {/* Divider */}
          <div className="flex items-center gap-4 my-6">
            <div className="flex-1 h-[1px] bg-white/10" />
            <span className="text-gray-400 text-sm">or</span>
            <div className="flex-1 h-[1px] bg-white/10" />
          </div>

          {/* Sign up link */}
          <div className="text-center">
            <p className="text-gray-400 text-sm">
              Don't have an account?{' '}
              <button
                onClick={() => navigate('/patient-signup')}
                className="text-white hover:underline"
              >
                Create Account
              </button>
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
