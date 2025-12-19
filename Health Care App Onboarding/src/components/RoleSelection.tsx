import { motion } from 'motion/react';
import { useNavigate } from 'react-router-dom';
import { Stethoscope, User } from 'lucide-react';
import logo from 'figma:asset/67deb029e390c772cc33e8e748e86b0188280ecc.png';

export default function RoleSelection() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-6 relative overflow-hidden">
      {/* Background logo with blur */}
      <div className="absolute inset-0 flex items-center justify-center opacity-5">
        <img src={logo} alt="" className="w-[600px] h-auto blur-sm" />
      </div>

      {/* Grid pattern overlay */}
      <div className="absolute inset-0 opacity-5">
        <div className="w-full h-full" style={{
          backgroundImage: 'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
          backgroundSize: '50px 50px'
        }} />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="relative z-10 w-full max-w-md"
      >
        {/* Logo at top */}
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ delay: 0.2 }}
          className="flex justify-center mb-12"
        >
          <img src={logo} alt="Medi Nexus" className="w-48 h-auto" />
        </motion.div>

        {/* Title */}
        <motion.h1
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4 }}
          className="text-white text-center mb-3"
        >
          Welcome to Medi Nexus
        </motion.h1>
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="text-gray-400 text-center mb-12"
        >
          Select your role to continue
        </motion.p>

        {/* Role buttons */}
        <div className="space-y-4">
          <motion.button
            initial={{ x: -50, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            transition={{ delay: 0.6 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => navigate('/doctor-signin')}
            className="w-full p-6 rounded-2xl border border-white/10 backdrop-blur-xl bg-white/5 hover:bg-white/10 transition-all group relative overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-white/0 via-white/5 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700" />
            <div className="relative flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-white/10 flex items-center justify-center">
                  <Stethoscope className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <div className="text-white">Sign in as Doctor</div>
                  <div className="text-gray-400 text-sm">Medical professionals</div>
                </div>
              </div>
              <div className="text-white opacity-50 group-hover:opacity-100 transition-opacity">→</div>
            </div>
          </motion.button>

          <motion.button
            initial={{ x: 50, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            transition={{ delay: 0.7 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => navigate('/patient-signin')}
            className="w-full p-6 rounded-2xl border border-white/10 backdrop-blur-xl bg-white/5 hover:bg-white/10 transition-all group relative overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-white/0 via-white/5 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700" />
            <div className="relative flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-white/10 flex items-center justify-center">
                  <User className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <div className="text-white">Sign in as Patient</div>
                  <div className="text-gray-400 text-sm">Healthcare seekers</div>
                </div>
              </div>
              <div className="text-white opacity-50 group-hover:opacity-100 transition-opacity">→</div>
            </div>
          </motion.button>
        </div>
      </motion.div>
    </div>
  );
}
