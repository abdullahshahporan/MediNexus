import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'motion/react';
import logo from 'figma:asset/67deb029e390c772cc33e8e748e86b0188280ecc.png';

export default function IntroPage() {
  const navigate = useNavigate();
  const [showLogo, setShowLogo] = useState(false);

  useEffect(() => {
    setShowLogo(true);
    const timer = setTimeout(() => {
      navigate('/role-selection');
    }, 3000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="min-h-screen bg-black flex items-center justify-center overflow-hidden relative">
      {/* Animated background elements */}
      <div className="absolute inset-0">
        {[...Array(20)].map((_, i) => (
          <motion.div
            key={i}
            className="absolute w-1 h-1 bg-gray-500 rounded-full opacity-20"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
            }}
            animate={{
              scale: [1, 2, 1],
              opacity: [0.2, 0.5, 0.2],
            }}
            transition={{
              duration: 3,
              repeat: Infinity,
              delay: Math.random() * 2,
            }}
          />
        ))}
      </div>

      {/* Logo Animation */}
      <motion.div
        initial={{ scale: 0, opacity: 0, rotateY: 0 }}
        animate={
          showLogo
            ? {
                scale: [0, 1.2, 1],
                opacity: [0, 1, 1],
                rotateY: [0, 360],
              }
            : {}
        }
        transition={{
          duration: 2,
          ease: "easeOut",
        }}
        className="relative z-10"
      >
        <img src={logo} alt="Medi Nexus" className="w-80 h-auto" />
      </motion.div>

      {/* Light rays effect */}
      <motion.div
        className="absolute inset-0 opacity-10"
        animate={{
          background: [
            'radial-gradient(circle at 50% 50%, rgba(255,255,255,0.1) 0%, transparent 70%)',
            'radial-gradient(circle at 50% 50%, rgba(255,255,255,0.2) 0%, transparent 70%)',
            'radial-gradient(circle at 50% 50%, rgba(255,255,255,0.1) 0%, transparent 70%)',
          ],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
        }}
      />
    </div>
  );
}
